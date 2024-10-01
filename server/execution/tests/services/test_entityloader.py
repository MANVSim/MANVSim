import models
from app_config import db
from conftest import flask_app
from execution import run
from execution.entities.execution import Execution
from execution.entities.location import Location
from execution.entities.player import Player
from execution.entities.resource import Resource
from execution.entities.role import Role
from execution.entities.scenario import Scenario
from execution.services import entityloader
from media.media_data import MediaData


def _check_role(role: Role | None):
    assert role

    db_role = db.session.query(models.Role).filter_by(id=role.id).first()
    assert db_role
    assert db_role.name == role.name
    assert db_role.short_name == role.short_name
    assert db_role.power == role.power


def _check_players(players: list[Player], execution: Execution):
    assert False if players is None else True

    for player in players:
        p_tan = player.tan
        db_player = db.session.query(models.Player).filter_by(tan=p_tan).first()
        assert db_player is not None
        assert db_player.tan == player.tan
        assert db_player.alerted == player.alerted
        assert db_player.execution_id == execution.id
        assert db_player.role_id == player.role.id if player.role else False
        _check_role(player.role)
        # wont work with a location that has a hash generated location id the check is designed for equal location_ids in the game as well es db
        # _check_location(player.location, execution.scenario)
        assert player.name is None
        assert not player.accessible_locations
        assert not player.logged_in


def _check_scenario(scenario: Scenario):
    assert scenario

    db_scenario = db.session.query(models.Scenario).filter_by(
        id=scenario.id).first()
    assert db_scenario is not None
    assert db_scenario.id == scenario.id
    assert db_scenario.name == scenario.name


def _check_resource(resource: Resource, location: Location):
    assert resource

    db_resource = db.session.query(models.Resource).filter_by(
        id=resource.id).first()
    assert db_resource
    assert db_resource.name == resource.name
    assert db_resource.media_refs == MediaData.list_to_json(
        resource.media_references)
    assert db_resource.consumable == resource.consumable

    db_resource_mapping = db.session.query(models.ResourceInLocation).filter_by(
        resource_id=resource.id, location_id=location.id).first()
    assert db_resource_mapping is not None and db_resource_mapping.quantity == resource.quantity


def _check_location(location: Location | None, scenario: Scenario):
    assert location
    assert scenario

    db_location = db.session.query(models.Location).filter_by(
        id=location.id).first()
    assert db_location is not None
    assert db_location.name == location.name
    assert db_location.media_refs == MediaData.list_to_json(
        location.media_references)
    assert location.resources is not None
    if location.resources:
        map(lambda r: _check_resource(r, location), location.resources)

    children = db.session.query(models.LocationContainsLocation).filter_by(parent=location.id).all()
    for child in children:
        db_child = db.session.query(models.Location).filter_by(id=child.child).first()
        assert db_child is not None
        exec_child = scenario.locations.get(db_child.id)
        assert exec_child
        assert location in exec_child.sub_locations


def _check_patients(scenario: Scenario):
    assert scenario

    db_patient_ids = map(lambda tpi: tpi.patient_id,
                         db.session.query(models.PatientInScenario).filter_by(
                             scenario_id=scenario.id).all())
    db_patients: list[models.Patient] = db.session.query(models.Patient).filter(
        models.Patient.id.in_(db_patient_ids)).all()

    for db_patient in db_patients:
        continue
        # FIXME wont work with a patient that has a hash generated patient id. The check is designed for equal patient_ids in the game as well es db
        exec_patient = scenario.patients.get(db_patient.id)
        assert exec_patient
        db_mapping = db.session.query(models.PatientInScenario).filter_by(scenario_id=scenario.id,
                                                                    patient_id=db_patient.id).first()
        assert db_mapping
        assert db_mapping.name == exec_patient.name
        assert True if db_patient.activity_diagram is not None and exec_patient.activity_diagram is not None \
            else db_patient.activity_diagram is None
        # If a patient has no location, a generic one is created at runtime, so
        # this check does not need to be applied
        if db_patient.location is not None:
            assert db_patient.location == exec_patient.location.id
            _check_location(exec_patient.location, scenario)
        if db_patient.media_refs is not None:
            assert db_patient.media_refs == MediaData.list_to_json(exec_patient.media_references)


def _check_actions(scenario: Scenario):
    assert scenario

    db_actions: list[models.Action] = db.session.query(models.Action).all()
    assert len(db_actions) == len(scenario.actions.values())
    for db_action in db_actions:
        exec_action = scenario.actions.get(db_action.id)
        assert exec_action
        assert db_action.name == exec_action.name
        assert db_action.media_refs == MediaData.list_to_json(
            exec_action.media_references)
        assert db_action.duration_secs == exec_action.duration_sec
        assert db_action.required_power == exec_action.required_power
        assert True if db_action.results is not None and exec_action.results is not None \
            else db_action.results is None


def test_load_execution():
    # Clear state before actual test
    run.active_executions = {}
    run.registered_players = {}

    with flask_app.app_context():
        # Load Executions from DB
        db_execs = db.session.query(models.Execution).all()
        for ex in db_execs:
            assert entityloader.load_execution(ex.id)

        # Retrieve loaded executions
        executions = run.active_executions.values()
        for ex in executions:
            # Test properties of entity objects
            _check_players(ex.players.values(), ex)
            _check_scenario(ex.scenario)
            _check_patients(ex.scenario)
            _check_actions(ex.scenario)
            assert ex.status == Execution.Status.PENDING
            assert ex.name is not None
            assert ex.starting_time == -1

    # CLEANUP - The fixture clean up of pytest does not apply after this test.
    run.active_executions = {}
