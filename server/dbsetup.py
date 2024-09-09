from bcrypt import gensalt, hashpw

from app import create_app
from app_config import db, csrf
from execution.tests.entities.dummy_entities import get_activity_diagrams
from media.media_data import MediaData
from models import (
    Scenario,
    Execution,
    Location, LocationContainsLocation,
    Role,
    Player,
    Patient,
    PatientInScenario,
    Resource,
    Action,
    ResourcesNeeded,
    WebUser, ResourceInLocation, PlayersToVehicleInExecution,
)
from vars import RESULT_DELIMITER


# pyright: reportCallIssue=false
# The following statements are excluded from pyright, due to ORM specifics.
# Additionally, the sample data is not required for production.


def __create_resources():
    insert(
        Resource(id=0, name="Verband", media_refs=MediaData.list_to_json([
            MediaData.new_image("media/static/image/no_image.png")]),
                 consumable=True))
    insert(
        Resource(id=1, name="Pflaster", media_refs=MediaData.list_to_json([
            MediaData.new_image("media/static/image/no_image.png")]),
                 consumable=True))
    insert(Resource(id=2, name="Stetoskop",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")]),
                    consumable=False))
    insert(Resource(id=3, name="Knochensäge",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")]),
                    consumable=False))
    insert(Resource(id=4, name="EKG", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/tasche_ekg.jpg")])))
    insert(Resource(id=5, name="Infusion", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")])))
    insert(Resource(id=6, name="Trage", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")])))
    insert(Resource(id=7, name="Beatmungsgerät", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")])))

    insert(ResourceInLocation(id=0, quantity=10,
                              location_id=2, resource_id=0))
    insert(ResourceInLocation(id=1, quantity=10000,
                              location_id=3, resource_id=1))
    insert(ResourceInLocation(id=2, quantity=2,
                              location_id=1, resource_id=2))
    insert(ResourceInLocation(id=3, quantity=1,
                              location_id=0, resource_id=3))
    insert(ResourceInLocation(id=4, quantity=1,
                              location_id=5, resource_id=4))
    insert(ResourceInLocation(id=5, quantity=3,
                              location_id=3, resource_id=5))
    insert(ResourceInLocation(id=6, quantity=4,
                              location_id=0, resource_id=6))
    insert(ResourceInLocation(id=7, quantity=1,
                              location_id=4, resource_id=7))


def __create_locations():
    insert(Location(id=0, name="RTW", is_vehicle=True,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/rtw_sh.png")])))
    insert(Location(id=1, name="Sichtungstasche",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/tasche_sichtung.jpg")])))
    insert(Location(id=2, name="Verbandskasten",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/tasche_rot.jpg")])))
    insert(Location(id=3, name="Roter Rucksack",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/rucksack_rot.jpg")])))
    insert(Location(id=4, name="Blauer Rucksack",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/rucksack_blau.jpg")])))
    insert(Location(id=5, name="EKG", media_refs=MediaData.list_to_json([
        MediaData.new_image("media/static/image/tasche_ekg.jpg")])))
    insert(Location(id=6, name="Holstein Stadion",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")])))

    insert(LocationContainsLocation(id=0, parent=0, child=1))
    insert(LocationContainsLocation(id=1, parent=0, child=2))
    insert(LocationContainsLocation(id=2, parent=0, child=3))
    insert(LocationContainsLocation(id=3, parent=0, child=4))
    insert(LocationContainsLocation(id=4, parent=0, child=5))


def __create_actions():
    insert(Action(id=1, name="Verband anlegen", required_power=100,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results="",
                  duration_secs=60))
    insert(Action(id=2, name="Puls messen", required_power=100,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results="",
                  duration_secs=30))
    insert(Action(id=3, name="Pflaster aufkleben", required_power=0,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results="",
                  duration_secs=10))
    insert(Action(id=4, name="Amputation", required_power=300,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results="",
                  duration_secs=120))

    insert(Action(id=5, name="EKG schreiben",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_video("media/static/video/test.mp4"),
                      MediaData.new_audio("media/static/audio/test.wav")]),
                  duration_secs=2, results=f"EKG{RESULT_DELIMITER}12-Kanal-EKG",
                  required_power=200))
    insert(Action(id=6, name="Pflaster kleben",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=10, results="", required_power=300))
    insert(Action(id=7, name="Beatmen", media_refs=MediaData.list_to_json([
        MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=300, results="", required_power=200))
    insert(
        Action(id=8, name="Betrachten", media_refs=MediaData.list_to_json([
            MediaData.new_image("media/static/image/no_image.png")]),
               duration_secs=5, required_power=100,
               results=f"Verletzung{RESULT_DELIMITER}Haut{RESULT_DELIMITER}\
               Bewusstsein"))
    insert(Action(id=9, name="Wunderheilung",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=5, results="", required_power=300))

    # PROD DATA
    insert(Action(id=0, name="Transportiere Patient zu", required_power=0,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/no_image.png")]),
                  results="", duration_secs=40))


def __resource_needed():
    insert(ResourcesNeeded(action_id=1, resource_id=0))
    insert(ResourcesNeeded(action_id=2, resource_id=2))
    insert(ResourcesNeeded(action_id=3, resource_id=1))
    insert(ResourcesNeeded(action_id=4, resource_id=3))

    insert(ResourcesNeeded(action_id=5, resource_id=4))
    insert(ResourcesNeeded(action_id=6, resource_id=1))
    insert(ResourcesNeeded(action_id=7, resource_id=7))


def __create_roles():
    insert(Role(id=0, name="Passant", power=0))
    insert(Role(id=1, name="Rettungsanitäter", short_name="Sani", power=100))
    insert(Role(id=2, name="Rettungsassistent", short_name="Assistent",
                power=200))
    insert(Role(id=3, name="Notarzt", short_name="Arzt", power=300))


def __create_players():
    insert(Player(tan="123ABC", execution_id=1, location_id=0, role_id=1,
                  alerted=True))
    insert(Player(tan="987ZYX", execution_id=2, location_id=0,
                  role_id=2, alerted=True))
    insert(Player(tan="654WVU", execution_id=2, location_id=0, role_id=3,
                  alerted=False))

    insert(PlayersToVehicleInExecution(execution_id=4, scenario_id=2, player_tan="123ABC",
                                       location_id=0, vehicle_name="RTW I", travel_time=120))
    insert(PlayersToVehicleInExecution(execution_id=5, scenario_id=2, player_tan="987ZYX",
                                       location_id=0, vehicle_name="RTW I", travel_time=10))
    insert(PlayersToVehicleInExecution(execution_id=5, scenario_id=2, player_tan="654WVU",
                                       location_id=0, vehicle_name="RTW II", travel_time=10))


def __create_patients():
    ads = get_activity_diagrams()

    insert(Patient(id=0, template_name="Alter Mann, ohne Befund", activity_diagram=(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image("media/static/image/no_image.png")])))
    insert(Patient(id=1, template_name="Leichte äußere Verletzungen",
                   activity_diagram=ads[0].to_json(), media_refs=MediaData.list_to_json(
                       [MediaData.new_image("media/static/image/no_image.png")])))
    insert(Patient(id=2, template_name="Blaues Auge",
                   activity_diagram=ads[1].to_json(), media_refs=MediaData.list_to_json(
                       [MediaData.new_text("Eine beispielhafte Patientenbeschreibung")])))
    insert(Patient(id=3, template_name="Schwerer Schlaganfall mit inneren Blutungen",
                   activity_diagram=ads[2].to_json()))
    insert(Patient(id=4, template_name="Gesund, keine Verletzungen",
                   activity_diagram=ads[3].to_json()))
    insert(Patient(id=5, template_name="Adipöse Frau", activity_diagram=(), media_refs=MediaData.list_to_json(
                       [MediaData.new_image("media/static/image/no_image.png")])))


def __create_scenarios():
    insert(Scenario(id=0, name="Busunglück"))
    insert(Scenario(id=1, name="Autounfall"))
    insert(Scenario(id=2, name="Schlägerei"))
    insert(Scenario(id=3, name="Gasexplosion"))


def __takes_part_in():
    insert(PatientInScenario(scenario_id=0, patient_id=0, name="Hans"))
    insert(PatientInScenario(scenario_id=0, patient_id=5, name="Gisela"))
    insert(PatientInScenario(scenario_id=2, patient_id=1, name="Holger Hooligan"))
    insert(PatientInScenario(scenario_id=2, patient_id=2, name="Stefan Schiri"))
    insert(PatientInScenario(scenario_id=2, patient_id=3, name="Hoff Nungs Loserfall"))
    insert(PatientInScenario(scenario_id=2, patient_id=4, name="Hoff Nungs Vollerfall"))


def __create_executions():
    insert(Execution(id=3, name="Übungssimulation \"Busunglück\" 2024",
                     scenario_id=0))
    insert(Execution(id=4, name="Dummy Execution 2024", scenario_id=2))
    insert(Execution(id=5, name="Dummy Execution 2024 - zwei Wagen", scenario_id=2))


def insert(data):
    db.session.add(data)


with create_app(csrf=csrf, db=db).app_context():
    __create_executions()
    __create_scenarios()
    __create_players()
    __create_roles()
    __create_patients()
    __create_locations()
    __create_resources()
    __create_actions()
    __resource_needed()
    __takes_part_in()

    insert(WebUser(username="wadmin",
                   password=hashpw(b"pw1234", gensalt()).decode(),
                   role=WebUser.Role.WEB_ADMIN.name))

    insert(WebUser(username="sadmin",
                   password=hashpw(b"pw1234", gensalt()).decode(),
                   role=WebUser.Role.SCENARIO_ADMIN.name))

    insert(WebUser(username="gmaster",
                   password=hashpw(b"pw1234", gensalt()).decode(),
                   role=WebUser.Role.GAME_MASTER.name))

    insert(WebUser(username="read",
                   password=hashpw(b"pw1234", gensalt()).decode(),
                   role=WebUser.Role.READ_ONLY.name))

    db.session.commit()
