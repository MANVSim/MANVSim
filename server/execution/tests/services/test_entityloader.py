import models
from app import create_app
from app_config import db, csrf
from execution import run
from execution.entities.execution import Execution
from execution.entities.location import Location
from execution.entities.player import Player
from execution.entities.resource import Resource
from execution.entities.role import Role
from execution.entities.scenario import Scenario
from execution.services import entityloader
from execution.tests.conftest import flask_app


def _check_role(role: Role):
    assert role

    db_role: models.Role = db.session.query(models.Role).filter_by(id=role.id).first()
    assert db_role
    assert db_role.name == role.name
    assert db_role.short_name == role.short_name
    assert db_role.power == role.power


def _check_players(players: list[Player], execution: Execution):
    assert False if players is None else True

    for player in players:
        print(player)
        p_tan = player.tan
        db_player = db.session.query(models.Player).filter_by(tan=p_tan).first()
        assert db_player is not None
        assert db_player.tan == player.tan
        assert db_player.alerted == player.alerted
        assert db_player.execution_id == execution.id
        assert db_player.activation_delay_sec == player.activation_delay_sec
        assert db_player.role_id == player.role.id
        _check_role(player.role)
        assert db_player.location_id == player.location.id
        _check_location(player.location, execution.scenario)
        assert player.name is None
        assert not player.accessible_locations
        assert not player.logged_in


def _check_scenario(scenario: Scenario):
    assert scenario

    db_scenario = db.session.query(models.Scenario).filter_by(id=scenario.id).first()
    assert db_scenario is not None
    assert db_scenario.id == scenario.id
    assert db_scenario.name == scenario.name


def _check_resource(resource: Resource, location: Location):
    assert resource

    db_resource: models.Resource = db.session.query(models.Resource).filter_by(id=resource.id).first()
    assert db_resource
    assert db_resource.name == resource.name
    assert db_resource.picture_ref == resource.picture_ref
    assert db_resource.location_id == location.id
    assert db_resource.quantity == resource.quantity


def _check_location(location: Location, scenario: Scenario):
    assert location
    assert scenario

    db_location: models.Location = db.session.query(models.Location).filter_by(id=location.id).first()
    assert db_location is not None
    assert db_location.name == location.name
    assert db_location.picture_ref == location.picture_ref
    assert location.resources is not None
    if location.resources:
        map(lambda r: _check_resource(r, location), location.resources)
    if db_location.location_id is not None:
        db_parent: models.Location = db.session.query(models.Location).filter_by(id=db_location.location_id).first()
        assert db_parent is not None
        exec_parent = scenario.locations.get(db_parent.id)
        assert location in exec_parent.sub_locations


def _check_patients(scenario: Scenario):
    assert scenario

    db_patient_ids = map(lambda tpi: tpi.patient_id,
                         db.session.query(models.TakesPartIn).filter_by(scenario_id=scenario.id).all())
    db_patients: list[models.Patient] = db.session.query(models.Patient).filter(
        models.Patient.id.in_(db_patient_ids)).all()

    assert len(db_patients) == len(scenario.patients.values())
    for db_patient in db_patients:
        exec_patient = scenario.patients.get(db_patient.id)
        assert exec_patient
        assert db_patient.name == exec_patient.name
        assert True if db_patient.activity_diagram is not None and exec_patient.activity_diagram is not None \
            else db_patient.activity_diagram is None
        # If a patient has no location, a generic one is created at runtime, so this check does not need to be applied
        if db_patient.location is not None:
            assert db_patient.location == exec_patient.location.id
            _check_location(exec_patient.location, scenario)


def _check_actions(scenario: Scenario):
    assert scenario

    db_actions: list[models.Action] = db.session.query(models.Action).all()
    assert len(db_actions) == len(scenario.actions.values())
    for db_action in db_actions:
        exec_action = scenario.actions.get(db_action.id)
        assert exec_action
        assert db_action.name == exec_action.name
        assert db_action.picture_ref == exec_action.picture_ref
        assert db_action.duration_secs == exec_action.duration_sec
        assert db_action.required_power == exec_action.required_power
        assert True if db_action.results is not None and exec_action.results is not None else db_action.results is None


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
