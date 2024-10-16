import uuid

import utils.time
from execution.entities.action import Action
from execution.entities.execution import Execution
from execution.entities.location import Location
from execution.entities.patient import Patient
from execution.entities.performed_action import PerformedAction
from execution.entities.player import Player
from execution.entities.resource import Resource
from execution.entities.role import Role
from execution.entities.scenario import Scenario
from execution.entities.stategraphs.activity_diagram import ActivityDiagram
from execution.entities.stategraphs.patientstate import PatientState
from media.media_data import MediaData
from vars import INCLUDE_TIMELIMIT, PATIENT_TIMELIMIT


# -- Create Test Scenario/Execution --

def create_test_execution(pending: bool = True):
    # Resources
    res_1 = Resource(id=1, name="EKG", quantity=1,
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")],
                     consumable=False)
    res_2 = Resource(id=2, name="Infusion", quantity=3,
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")])
    res_3 = Resource(id=3, name="Trage", quantity=4,
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")],
                     consumable=False)
    res_4 = Resource(id=4, name="Blümchenpflaster", quantity=10000,
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")])
    res_5 = Resource(id=5, name="Beatmungsgerät", quantity=1,
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")],
                     consumable=False)

    # Locations
    loc_2 = Location(id=2, name="Roter Rucksack",
                     media_references=[
                         MediaData.new_image("media/static/image/rucksack_rot.jpg")],
                     resources=[res_2, res_4])
    loc_3 = Location(id=3, name="Blauer Rucksack",
                     media_references=[
                         MediaData.new_image("media/static/image/rucksack_blau.jpg")],
                     resources=[res_5])
    loc_4 = Location(id=4, name="EKG",
                     media_references=[
                         MediaData.new_image("media/static/image/tasche_ekg.jpg")],
                     resources=[res_1])
    loc_5 = Location(id=5, name="Holstein Stadion",
                     media_references=[MediaData.new_image(
                         "media/static/image/no_image.png")])
    loc_1 = Location(id=1, name="RTW", media_references=[
        MediaData.new_image("media/static/image/rtw_sh.png")],
                     resources=[res_3], sub_locations={loc_2, loc_3, loc_4})

    # Roles
    role_1 = Role(id=1, name="Notärzt:in", short_name="NA", power=400)
    role_2 = Role(id=2, name="Rettungsassistent:in", short_name="RA", power=200)

    # Players
    if pending:
        player_1 = Player(tan="123ABC", name="", location=loc_1,
                          accessible_locations={loc_2, loc_3, loc_4},
                          role=role_2, alerted=False, activation_delay_sec=10)
        player_2 = Player(tan="456DEF", name="", location=loc_1,
                          accessible_locations={loc_2, loc_3, loc_4},
                          role=role_1, alerted=False,
                          activation_delay_sec=10)
    else:
        player_1 = Player(tan="987ZYX", name="Frank Huch", location=loc_1,
                          accessible_locations={loc_2, loc_3, loc_4},
                          role=role_2, alerted=False, activation_delay_sec=10)
        player_2 = Player(tan="654WVU", name="Prof. Dr. Reinhard von Hanxleden",
                          location=loc_1,
                          accessible_locations={loc_2, loc_3, loc_4},
                          role=role_1, alerted=False,
                          activation_delay_sec=10)
        player_2.alert()

    # Actions
    action_1 = Action(id=1, name="EKG schreiben",
                      media_references=[MediaData.new_image(
                          "media/static/image/no_image.png")],
                      duration_sec=2,
                      results=["EKG", "12-Kanal-EKG"], resources_needed=["EKG"],
                      required_power=200)
    action_2 = Action(id=2, name="Pflaster kleben",
                      media_references=[MediaData.new_image(
                          "media/static/image/no_image.png")],
                      duration_sec=10,
                      results=[],
                      resources_needed=["Blümchenpflaster"], required_power=400)
    action_3 = Action(id=3, name="Beatmen",
                      media_references=[MediaData.new_image(
                          "media/static/image/no_image.png")],
                      duration_sec=300, results=[],
                      resources_needed=["Beatmungsgerät"], required_power=300)
    action_4 = Action(id=4, name="Betrachten",
                      media_references=[MediaData.new_image(
                          "media/static/image/no_image.png")],
                      duration_sec=5,
                      results=["Verletzung", "Haut", "Bewusstsein"],
                      resources_needed=[], required_power=200)
    action_5 = Action(id=5, name="Wunderheilung",
                      media_references=[MediaData.new_image(
                          "media/static/image/no_image.png")],
                      duration_sec=5, results=[],
                      resources_needed=[], required_power=400)

    # Performed Actions
    p_act_1 = PerformedAction(id="1", time=1715459280000, execution_id=1,
                              action=action_2, resources_used=[res_4],
                              player_tan="123ABC")

    ads = get_activity_diagrams()

    # Patients
    patient_1 = Patient(id=1, name="Holger Hooligan", activity_diagram=ads[0],
                        location=loc_5, performed_actions=[p_act_1])
    patient_2 = Patient(id=2, name="Stefan Schiri", activity_diagram=ads[1],
                        location=loc_5)
    patient_3 = Patient(id=3, name="Hoff Nungs Loserfall",
                        activity_diagram=ads[2],
                        location=loc_5)
    patient_4 = Patient(id=4, name="Hoff Nungs Vollerfall",
                        activity_diagram=ads[3],
                        location=loc_5)

    # Scenario
    location_dict = {
        1: loc_1,
        5: loc_5
    }
    patient_dict = {
        1: patient_1,
        2: patient_2,
        3: patient_3,
        4: patient_4
    }
    action_dict = {
        1: action_1,
        2: action_2,
        3: action_3,
        4: action_4,
        5: action_5
    }
    scenario = Scenario(s_id=1, name="Schlägerei", patients=patient_dict,
                        actions=action_dict, locations=location_dict)

    # Execution
    if pending:
        player_dict = {
            "123ABC": player_1,
            "456DEF": player_2
        }
    else:
        player_dict = {
            "987ZYX": player_1,
            "654WVU": player_2
        }
    exec_id = 1 if pending else 2
    exec_state = Execution.Status.PENDING if pending else Execution.Status.RUNNING
    execution = Execution(id=exec_id, name="Dummy Execution 2024",
                          scenario=scenario, starting_time=-1,
                          players=player_dict, status=exec_state)

    return execution


def get_activity_diagrams():
    conditions_s1 = {
        "RR": [MediaData.new_text("120/80mmHg")],
        "HF": [MediaData.new_text("80/min")],
        "AF": [MediaData.new_text("20/min")],
        "SpO2": [MediaData.new_text("95%")],
        "Radialispuls": [MediaData.new_text("tastbar, kräftig")],
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus ST-Hebung in II"),
                MediaData.new_image("media/static/image/no_image.png")],
        "12-Kanal-EKG": [MediaData.new_text("STEMI"),
                         MediaData.new_video("media/static/video/test.mp4",
                                             "12-Kanal-Bild")],
        "Haut": [MediaData.new_text("blass, kalt schweißig")],
        "Schmerz": [
            MediaData.new_text(
                "7(NAS) in der Brust, ausstrahlend in linken Arm")],
        "Bewusstsein": [MediaData.new_text("wach, orientiert")],
        "Psychischer Zustand": [MediaData.new_text("aengstlich")],
        "Verletzungen": [MediaData.new_text("keine")],
        "Temperatur": [MediaData.new_text("36,7°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }

    conditions_s2 = {
        "RR": [MediaData.new_text("70/50mmHg")],
        "HF": [MediaData.new_text("150/min")],
        "AF": [MediaData.new_text("20/min")],
        "SpO2": [MediaData.new_text("84%")],
        "Radialispuls": [MediaData.new_text("tastbar, schwach")],
        "Rekapzeit": [MediaData.new_text("2.5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus tachykarder Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "12-Kanal-EKG": [MediaData.new_text("tachykarder Sinusrhythmus"),
                         MediaData.new_image("media/static/image/no_image.png",
                                             "12-Kanal-Bild")],
        "Haut": [MediaData.new_text("blass, kalt schweißig, Lippenzyanose")],
        "Schmerz": [
            MediaData.new_text(
                "vorhanden, aber nicht quantitativ beurteilbar")],
        "Bewusstsein": [MediaData.new_text("reagiert auf Ansprache")],
        "Psychischer Zustand": [MediaData.new_text("nicht beurteilbar")],
        "Verletzungen": [MediaData.new_text(
            "klaffende Kopfplatzwunde, Knochenfragmente sichtbar"),
            MediaData.new_image("media/static/image/no_image.png")],
        "Temperatur": [MediaData.new_text("35,3°C")],
        "BZ": [MediaData.new_text("80 mg / dl")],
        "Auskultation": [
            MediaData.new_text("vesikuläre Atemgeräusche beidseitig")],
        "Abdomen": [MediaData.new_text("weich")],
    }

    conditions_s3 = {
        "RR": [MediaData.new_text("60/40mmHg")],
        "HF": [MediaData.new_text("140/min")],
        "AF": [MediaData.new_text("30/min")],
        "SpO2": [MediaData.new_text("82%")],
        "Radialispuls": [MediaData.new_text("nicht tastbar")],
        "Rekapzeit": [MediaData.new_text("5s")],
        "EKG": [MediaData.new_text("Sinusrhythmus tachykarder Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "12-Kanal-EKG": [MediaData.new_text("tachykarder Sinusrhythmus"),
                         MediaData.new_image("media/static/image/no_image.png",
                                             "12-Kanal-Bild")],
        "Haut": [MediaData.new_text("blass, kalt schweißig, Lippenzyanose")],
        "Schmerz": [
            MediaData.new_text(
                "vorhanden, aber nicht quantitativ beurteilbar")],
        "Bewusstsein": [MediaData.new_text("reagiert auf Schmerzreiz")],
        "Psychischer Zustand": [MediaData.new_text("nicht beurteilbar")],
        "Verletzungen": [MediaData.new_text("amputierter linker Unterschenkel, "
                                            "Prellmarken an Bauch und Brust, linker"
                                            " Oberarm gebrochen, Knochensplitter "
                                            "steht vor")],
        "Temperatur": [MediaData.new_text("35,3°C")],
        "DMS": [MediaData.new_text("keine Gefühl in linker Hand")],
        "BZ": [MediaData.new_text("80 mg/dl")],
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
        "EKG": [MediaData.new_text("Sinusrhythmus"),
                MediaData.new_image("media/static/image/no_image.png")],
        "12-Kanal-EKG": [MediaData.new_text("STEMI"),
                         MediaData.new_image("media/static/image/no_image.png",
                                             "12-Kanal-Bild")],
        "Haut": [MediaData.new_text("normal, trocken")],
        "Schmerz": [
            MediaData.new_text(
                "0 (NAS)")],
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
        "Rekapzeit": [MediaData.new_text("1.5s")],
        "EKG": [MediaData.new_text("Linie"),
                MediaData.new_image("media/static/image/no_image.png")],
        "12-Kanal-EKG": [MediaData.new_text("Linie"),
                         MediaData.new_image("media/static/image/no_image.png",
                                             "12-Kanal-Bild")],
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

    uuid_s1 = str(uuid.uuid4())
    uuid_s2 = str(uuid.uuid4())
    uuid_s3 = str(uuid.uuid4())
    uuid_s4 = str(uuid.uuid4())
    uuid_s5 = str(uuid.uuid4())

    treatment_s1 = {
        "1": uuid_s1,  # "EKG schreiben"
        "2": uuid_s1,  # "Pflaster kleben"
        "3": uuid_s1,  # "Beatmen"
        "4": uuid_s1,  # "Betrachten"
        "5": uuid_s4  # "Wunderheilung"
    }

    treatment_s2 = {
        "1": uuid_s2,
        "2": uuid_s2,
        "3": uuid_s2,
        "4": uuid_s2,
        "5": uuid_s4,
    }

    treatment_s3 = {
        "1": uuid_s3,
        "2": uuid_s3,
        "3": uuid_s3,
        "4": uuid_s3,
        "5": uuid_s4,
    }

    treatment_s4 = {
        "1": uuid_s4,
        "2": uuid_s4,
        "3": uuid_s4,
        "4": uuid_s4,
    }

    treatment_s5 = {
        "1": uuid_s5,
        "2": uuid_s5,
        "3": uuid_s5,
        "4": uuid_s5,
        "5": uuid_s5
    }

    s1 = PatientState(state_uuid=uuid_s1, treatments=treatment_s1,
                      conditions=conditions_s1)
    s2 = PatientState(state_uuid=uuid_s2, treatments=treatment_s2,
                      conditions=conditions_s2)
    s3 = PatientState(state_uuid=uuid_s3, treatments=treatment_s3,
                      conditions=conditions_s3) if not INCLUDE_TIMELIMIT \
        else (PatientState(state_uuid=uuid_s3, treatments=treatment_s3,
                           conditions=conditions_s3,
                           start_time=utils.time.current_time_s(),
                           timelimit=PATIENT_TIMELIMIT,
                           after_time_state_uuid=uuid_s5))

    s4 = PatientState(state_uuid=uuid_s4, treatments=treatment_s4,
                      conditions=healthy_conditions)
    s5 = PatientState(state_uuid=uuid_s5, treatments=treatment_s5,
                      conditions=dead)

    acd1 = ActivityDiagram(root=s1, states=[s1, s4])
    acd2 = ActivityDiagram(root=s2, states=[s2, s4])
    acd3 = ActivityDiagram(root=s3, states=[s3, s4, s5]) if INCLUDE_TIMELIMIT \
        else ActivityDiagram(root=s3, states=[s3, s4])
    acd4 = ActivityDiagram(root=s4, states=[s4])

    return acd1, acd2, acd3, acd4
