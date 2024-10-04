import logging
import uuid

from bcrypt import gensalt, hashpw
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from app import create_app
from app_config import db, csrf
from execution.entities.stategraphs.activity_diagram import ActivityDiagram
from execution.entities.stategraphs.patientstate import PatientState
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


def __create_locations():
    # Vehicle
    insert(Location(id=0, name="RTW", is_vehicle=True,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_text(
                            text="Der Rettungswagen transportiert Spieler zum Einsatzort. Im "
                                 "Rettungswagen werden Resourcen gelagert. Diese können ins "
                                 "Inventar genommen werden oder Patienten können zur Behandlung "
                                 "dorthin gebracht werden."),
                        MediaData.new_image("media/static/image/rtw_sh.png")])))
    insert(Location(id=1, name="NEF", is_vehicle=True,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/nef_sh.png")])))
    # Resource-Holding
    insert(Location(id=2, name="EKG", media_refs=MediaData.list_to_json([
        MediaData.new_image("media/static/image/tasche_ekg.jpg")])))
    insert(Location(id=3, name="Roter Notfallrucksack",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/rucksack_rot.jpg")])))
    insert(Location(id=4, name="Heilige Tasche",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/rucksack_blau.jpg")])))
    insert(Location(id=6, name="Verbandskasten",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/tasche_rot.jpg")])))
    # Patient-Locations
    insert(Location(id=7, name="Eingestürztes Haus",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/ruine_haus.jpg")])))
    insert(Location(id=8, name="Autowrack",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/auto_wrack.jpg")])))
    insert(Location(id=9, name="Uni-Hochhaus",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/unihochhaus.jpg")])))
    insert(Location(id=10, name="Quarantäne-Zone",
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image("media/static/image/quarantaene_zone.jpg")])))

    # RTW:
    insert(LocationContainsLocation(id=0, parent=0, child=2))  # EKG
    insert(LocationContainsLocation(id=1, parent=0, child=3))  # Roter Rucksack
    insert(LocationContainsLocation(id=2, parent=0, child=3))  # Roter Rucksack
    insert(LocationContainsLocation(id=3, parent=0, child=6))  # Verbandskasten

    # NEF:
    insert(LocationContainsLocation(id=4, parent=1, child=4))  # Heilige Tasche
    insert(LocationContainsLocation(id=5, parent=1, child=6))  # Verbandskasten


def __create_resources():
    insert(Resource(id=0, name="EKG", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/tasche_ekg.jpg")])))
    insert(Resource(id=1, name="Spritze", consumable=True,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/spritze.png")])))
    insert(Resource(id=2, name="Infusion", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/transfusion.png")])))
    insert(Resource(id=3, name="Verband", consumable=True,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/no_image.png")])))
    insert(Resource(id=4, name="Knochensäge", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/saege.png")])))
    insert(Resource(id=6, name="Bibel", consumable=False,
                    media_refs=MediaData.list_to_json([
                        MediaData.new_image(
                            "media/static/image/bible.png")])))

    # EKG in EKG Tasche
    insert(ResourceInLocation(id=0, quantity=1,
                              location_id=2, resource_id=0))
    # Roter Rucksack
    insert(ResourceInLocation(id=1, quantity=20,
                              location_id=3, resource_id=1))
    insert(ResourceInLocation(id=2, quantity=2,
                              location_id=3, resource_id=2))
    insert(ResourceInLocation(id=3, quantity=1,
                              location_id=3, resource_id=4))
    # Verbandskasten
    insert(ResourceInLocation(id=4, quantity=10000,
                              location_id=6, resource_id=3))
    # Heilige Tasche
    insert(ResourceInLocation(id=5, quantity=1,
                              location_id=4, resource_id=6))


def __resource_needed():
    insert(ResourcesNeeded(action_id=2, resource_id=0))
    insert(ResourcesNeeded(action_id=3, resource_id=1))
    insert(ResourcesNeeded(action_id=4, resource_id=2))
    insert(ResourcesNeeded(action_id=5, resource_id=3))
    insert(ResourcesNeeded(action_id=6, resource_id=4))
    insert(ResourcesNeeded(action_id=7, resource_id=6))


def __create_actions():
    insert(Action(id=0, name="Patient händisch untersuchen",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=10,
                  required_power=100,
                  results=f"Verletzungen{RESULT_DELIMITER}Haut{RESULT_DELIMITER}"
                          f"Abdomen{RESULT_DELIMITER}Rekapzeit"))
    insert(Action(id=1, name="Patient ansprechen",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=10,
                  required_power=100,
                  results=f"Bewusstsein{RESULT_DELIMITER}Schmerz"
                          f"{RESULT_DELIMITER}Psychischer Zustand"))
    insert(Action(id=2, name="EKG messen",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_video("media/static/video/test.mp4"),
                      MediaData.new_audio("media/static/audio/test.wav")]),
                  duration_secs=20,
                  required_power=100,
                  results=f"EKG"))
    insert(Action(id=3, name="Adrenalin spritzen",
                  media_refs=MediaData.list_to_json([MediaData.new_image(
                      "media/static/image/adrenalin-spritzen.png")]),
                  duration_secs=5,
                  required_power=200,
                  results=f"EKG{RESULT_DELIMITER}Psychischer Zustand"))
    insert(Action(id=4, name="Schmerzmittel verabreichen",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  duration_secs=5,
                  required_power=200,
                  results=f"Schmerz"))
    insert(Action(id=5, name="Verband anlegen", required_power=100,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results=f"Verletzungen",
                  duration_secs=20))
    insert(Action(id=6, name="Amputation", required_power=300,
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image("media/static/image/no_image.png")]),
                  results="Verletzungen",
                  duration_secs=30))

    insert(Action(id=7, name="Wunderheilung",
                  media_refs=MediaData.list_to_json([
                      MediaData.new_image(
                          "media/static/image/wunderheilung.png")]),
                  duration_secs=30, results="", required_power=300))


def __create_roles():
    insert(Role(id=0, name="Rettungssanitäter:in", short_name="RettSan", power=100))
    insert(Role(id=1, name="Rettungsassistent:in", short_name="RettAss", power=200))
    insert(Role(id=3, name="Notfallsanitäter:in", short_name="NotSan", power=250))
    insert(Role(id=2, name="Notarzt:in", short_name="NotAss", power=300))


def __create_players():
    # RTW KI 1
    insert(Player(tan="97ZN9H", execution_id=1, location_id=0, role_id=1,
                  alerted=False))
    insert(Player(tan="549Q4Z", execution_id=1, location_id=0, role_id=0,
                  alerted=False))
    # NEF ECK 1
    insert(Player(tan="4WT35Q", execution_id=1, location_id=1, role_id=2,
                  alerted=False))
    insert(Player(tan="J6V8A6", execution_id=1, location_id=1, role_id=3,
                  alerted=False))
    # RTW PLÖ 1
    insert(Player(tan="RFO549", execution_id=1, location_id=0, role_id=1,
                  alerted=False))
    # RTW KI 2
    insert(Player(tan="62ZH68", execution_id=1, location_id=0, role_id=1,
                  alerted=False))
    # RTW ECK 1
    insert(Player(tan="E5Q619", execution_id=1, location_id=0, role_id=1,
                  alerted=False))
    # NEF KI 1
    insert(Player(tan="Y15KG3", execution_id=1, location_id=1, role_id=2,
                  alerted=False))

    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="97ZN9H",
                                       location_id=0, vehicle_name="RTW-KI-1", travel_time=30))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="549Q4Z",
                                       location_id=0, vehicle_name="RTW-KI-1", travel_time=30))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="4WT35Q",
                                       location_id=1, vehicle_name="NEF-ECK-1", travel_time=50))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="J6V8A6",
                                       location_id=1, vehicle_name="NEF-ECK-1", travel_time=50))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="RFO549",
                                       location_id=0, vehicle_name="RTW-PLÖ-1", travel_time=60))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="62ZH68",
                                       location_id=0, vehicle_name="RTW-KI-2", travel_time=30))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="E5Q619",
                                       location_id=0, vehicle_name="RTW-ECK-1", travel_time=50))
    insert(PlayersToVehicleInExecution(execution_id=1, scenario_id=0, player_tan="Y15KG3",
                                       location_id=1, vehicle_name="NEF-KI-1", travel_time=30))


def __create_patients():
    acds = __create_activity_diagrams()

    insert(Patient(id=0, template_name="Schockpatient",
                   activity_diagram=acds[0].to_json(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image(
                           "media/static/image/schockpatient.png")])))
    insert(Patient(id=1, template_name="Allergie-Patient",
                   activity_diagram=acds[1].to_json(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image(
                           "media/static/image/allergiepatient.png")])))
    insert(Patient(id=2, template_name="Schnittwunden-Patient",
                   activity_diagram=acds[2].to_json(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image(
                           "media/static/image/woundedpatient.png")])))
    insert(Patient(id=3, template_name="Infizierter Patient",
                   activity_diagram=acds[3].to_json(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image(
                           "media/static/image/hide_the_pain.png")])))
    insert(Patient(id=4, template_name="Toter Patient/Walker",
                   activity_diagram=acds[4].to_json(),
                   media_refs=MediaData.list_to_json(
                       [MediaData.new_image(
                           "media/static/image/zombie.png")])))


def __patient_in_scenario():
    # Schock
    insert(PatientInScenario(scenario_id=0, patient_id=0, name="Thomas Meier", location_id=7))
    insert(PatientInScenario(scenario_id=0, patient_id=0, name="Hans Schmidt", location_id=8))
    # Allergie
    insert(PatientInScenario(scenario_id=0, patient_id=1, name="Andreas Fischer", location_id=7))
    # Schnittwunde
    insert(PatientInScenario(scenario_id=0, patient_id=2, name="Maria Müller", location_id=7))
    insert(PatientInScenario(scenario_id=0, patient_id=2, name="Lisa Wagner", location_id=8))
    # Infiziert
    insert(PatientInScenario(scenario_id=0, patient_id=3, name="Stefan Becker", location_id=9))

    # Dead (Zombies)
    insert(PatientInScenario(scenario_id=0, patient_id=4, name="Waltraud Wiedergänger", location_id=9))
    insert(PatientInScenario(scenario_id=0, patient_id=4, name="Gertrud Gierig", location_id=9))
    insert(PatientInScenario(scenario_id=0, patient_id=4, name="Herbert Fleischmann", location_id=9))
    insert(PatientInScenario(scenario_id=0, patient_id=4, name="Heinz Hirntot", location_id=10))


def __create_scenarios():
    insert(Scenario(id=0, name="MANVSim-Demo-Szenario"))


def __create_executions():
    insert(Execution(id=1, name="Präsentationssimulation 27.09.2024", scenario_id=0))


def insert(data):
    db.session.add(data)
    db.session.commit()


def __create_activity_diagrams():
    uuid_s1 = str(uuid.uuid4())  # p0-current
    uuid_s2 = str(uuid.uuid4())  # p0-amputation
    uuid_s3 = str(uuid.uuid4())  # p1-current
    uuid_s4 = str(uuid.uuid4())  # p1-adrenalin
    uuid_s5 = str(uuid.uuid4())  # p2-current
    uuid_s6 = str(uuid.uuid4())  # p2-schmerzmittel
    uuid_s7 = str(uuid.uuid4())  # p2-verband
    uuid_s8 = str(uuid.uuid4())  # p3-current
    uuid_s9 = str(uuid.uuid4())  # p3-amputation
    uuid_s10 = str(uuid.uuid4())  # healthy
    uuid_s11 = str(uuid.uuid4())  # dead

    # Patient-0
    treatment_s1 = {
        "6": uuid_s2,  # Amputieren
    }

    # Patient-1
    treatment_s3 = {
        "3": uuid_s4,  # Adrenalin
        "6": uuid_s11,  # Amputieren
    }

    treatment_s4 = {
        "6": uuid_s11,  # Amputieren
    }

    # Patient-2
    treatment_s5 = {
        "4": uuid_s6,  # Schmerzmittel
        "5": uuid_s7,  # Verband
        "6": uuid_s11,  # Amputieren
    }
    treatment_s6 = {
        "5": uuid_s10,  # Verband
        "6": uuid_s11,  # Amputieren
    }
    treatment_s7 = {
        "4": uuid_s6,  # Schmerzmittel
        "6": uuid_s11,  # Amputieren
    }

    # Patient-3
    treatment_s8 = {
        "6": uuid_s9,  # Amputieren
    }
    treatment_s9 = {
        "7": uuid_s10,  # Wunderheilung
    }
    s1_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("80/min")],
        "AF": [MediaData.new_text("12/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("bleich, trocken")],
        "Schmerz": [MediaData.new_text("0 (NAS)")],
        "Bewusstsein": [MediaData.new_text("leicht abwesend, desorientiert")],
        "Psychischer Zustand": [MediaData.new_text("verheult, "
                                                   "zögernd beim Antworten")],
        "Verletzungen": [MediaData.new_text("keine")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s2_conditions = {
        "RR": [MediaData.new_text("Patient wehrt sich")],
        "HF": [MediaData.new_text("Patient wehrt sich")],
        "AF": [MediaData.new_text("Patient wehrt sich")],
        "SpO2": [MediaData.new_text("Patient wehrt sich")],
        "Radialispuls": [MediaData.new_text("Patient wehrt sich")],
        "Rekapzeit": [MediaData.new_text("Patient wehrt sich")],
        "EKG": [MediaData.new_text("Patient wehrt sich")],
        "Haut": [MediaData.new_text("bleich")],
        "Schmerz": [MediaData.new_text("Patient wehrt sich")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("distanziert und verweigert"
                                                   "weitere Untersuchungen")],
        "Verletzungen": [MediaData.new_text("Patient wehrt sich")],
        "Temperatur": [MediaData.new_text("Patient wehrt sich")],
        "BZ": [MediaData.new_text("Patient wehrt sich")],
        "Auskultation": [MediaData.new_text("Patient wehrt sich")],
        "Abdomen": [MediaData.new_text("Patient wehrt sich")],
    }
    s3_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("120/min")],
        "AF": [MediaData.new_text("16/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "Haut": [MediaData.new_text("roter Ausschlag an den Armen")],
        "Schmerz": [MediaData.new_text("2 (NAS), beklagt sich über Übelkeit")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("verunsichert")],
        "Verletzungen": [MediaData.new_text("kribbeln in den Handflächen "
                                            "und Fußsohlen")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s4_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("120/min")],
        "AF": [MediaData.new_text("13/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "Haut": [MediaData.new_text("roter Ausschlag an den Armen")],
        "Schmerz": [MediaData.new_text("2 (NAS), beklagt sich über Übelkeit")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("verunsichert")],
        "Verletzungen": [MediaData.new_text("keine")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s5_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("100/min")],
        "AF": [MediaData.new_text("12/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "Haut": [MediaData.new_text("normal, trocken")],
        "Schmerz": [MediaData.new_text("5 (NAS)")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("normal")],
        "Verletzungen": [MediaData.new_text("tiefere Schnittwunden am Bein und "
                                            "Torso, T-Shirt zerrissen")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s6_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("90/min")],
        "AF": [MediaData.new_text("12/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("normal, trocken")],
        "Schmerz": [MediaData.new_text("2 (NAS)")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("normal")],
        "Verletzungen": [MediaData.new_text("tiefere Schnittwunden am Bein und "
                                            "Torso, T-Shirt zerrissen")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s7_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("90/min")],
        "AF": [MediaData.new_text("12/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("normal, trocken")],
        "Schmerz": [
            MediaData.new_text(
                "5 (NAS)")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("normal")],
        "Verletzungen": [MediaData.new_text("behandelte Schnittwunden")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s8_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("70/min")],
        "AF": [MediaData.new_text("7/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, schwach")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("bleich, schweißig")],
        "Schmerz": [MediaData.new_text("10 (NAS)")],
        "Bewusstsein": [MediaData.new_text("kaum ansprechbar")],
        "Psychischer Zustand": [MediaData.new_text("n.a.")],
        "Verletzungen": [MediaData.new_text("Bisswunde im Bein mit hohem"
                                            " Blutverlust um das Bein herum")],
        "Temperatur": [MediaData.new_text("35,7°C")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    s9_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("70/min")],
        "AF": [MediaData.new_text("7/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, schwach")],
        "Rekapzeit": [MediaData.new_text("2.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("bleich, schweißig")],
        "Schmerz": [MediaData.new_text("n.a.")],
        "Bewusstsein": [MediaData.new_text("bewusstlos")],
        "Psychischer Zustand": [MediaData.new_text("n.a.")],
        "Verletzungen": [MediaData.new_text("Beinamputation erfolgte. "
                                            "Starke Blutung aus dem Bein")],
        "Temperatur": [MediaData.new_text("35,7°C")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    healthy_conditions = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("80/min")],
        "AF": [MediaData.new_text("12/min")],
        "SpO2": [MediaData.new_text("98%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus")],
        "Haut": [MediaData.new_text("normal, trocken")],
        "Schmerz": [MediaData.new_text("0 (NAS)")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("normal")],
        "Verletzungen": [MediaData.new_text("keine")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }
    dead = {
        "RR": [MediaData.new_text("0mmHg")],
        "HF": [MediaData.new_text("0/min")],
        "AF": [MediaData.new_text("0/min")],
        "SpO2": [MediaData.new_text("0%")],
        "Radialispuls": [MediaData.new_text("nicht tastbar")],
        "Rekapzeit": [MediaData.new_text("10s")],
        "EKG": [MediaData.new_text("Linie")],
        "Haut": [MediaData.new_text("kalt schweißig")],
        "Schmerz": [MediaData.new_text("keine")],
        "Bewusstsein": [MediaData.new_text("bewusstlos")],
        "Psychischer Zustand": [MediaData.new_text("n.a.")],
        "Verletzungen": [],
        "Temperatur": [MediaData.new_text("32°C")],
        "BZ": [MediaData.new_text("0 mg / dl")],
        "Auskultation": [],
        "Abdomen": [MediaData.new_text("weich")],
    }

    # States s1-s11
    # Patient - 0
    s1 = PatientState(state_uuid=uuid_s1, treatments=treatment_s1,
                      conditions=s1_conditions)
    s2 = PatientState(state_uuid=uuid_s2, treatments={},
                      conditions=s2_conditions)
    # Patient - 1
    s3 = PatientState(state_uuid=uuid_s3, treatments=treatment_s3,
                      conditions=s3_conditions)
    s4 = PatientState(state_uuid=uuid_s4, treatments=treatment_s4,
                      conditions=s4_conditions)

    # Patient - 2
    s5 = PatientState(state_uuid=uuid_s5, treatments=treatment_s5,
                      conditions=s5_conditions)
    s6 = PatientState(state_uuid=uuid_s6, treatments=treatment_s6,
                      conditions=s6_conditions)
    s7 = PatientState(state_uuid=uuid_s7, treatments=treatment_s7,
                      conditions=s7_conditions)

    # Patient - 3
    s8 = PatientState(state_uuid=uuid_s8, treatments=treatment_s8,
                      conditions=s8_conditions,
                      timelimit=600, after_time_state_uuid=uuid_s11)
    s9 = PatientState(state_uuid=uuid_s9, treatments=treatment_s9,
                      conditions=s9_conditions,
                      timelimit=1200, after_time_state_uuid=uuid_s11)

    # Other
    s10 = PatientState(state_uuid=uuid_s10, treatments={},
                       conditions=healthy_conditions)
    s11 = PatientState(state_uuid=uuid_s11, treatments={},
                       conditions=dead)

    # ActivityDiagram a0-a5
    acd1 = ActivityDiagram(root=s1, states=[s1, s2])  # Patient - 0
    acd2 = ActivityDiagram(root=s3, states=[s3, s4, s11])  # Patient - 1
    acd3 = ActivityDiagram(root=s5,
                           states=[s5, s6, s7, s10, s11])  # Patient - 2
    acd4 = ActivityDiagram(root=s8, states=[s8, s9, s10, s11])  # Patient - 3

    acd5 = ActivityDiagram(root=s11, states=[s11])  # dead patient

    return acd1, acd2, acd3, acd4, acd5


def db_setup(app: Flask = None, database: SQLAlchemy| None = None):
    if not app:
        app = create_app(csrf=csrf, db=database)
    if not database:
        logging.error("Empty database object provided. Unable to setup database.")
        return

    with app.app_context():
        __create_scenarios()
        __create_executions()
        __create_roles()
        __create_patients()
        __create_locations()
        __create_players()
        __create_resources()
        __create_actions()
        __resource_needed()
        __patient_in_scenario()

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

if __name__ == "__main__":
    db_setup(database=db)
