from app import create_app, db
from bcrypt import gensalt, hashpw
from models import (
    Scenario,
    Execution,
    Location,
    Role,
    Player,
    Patient,
    TakesPartIn,
    Resource,
    Action,
    ResourcesNeeded,
    WebUser,
)


def insert(data):
    db.session.add(data)


with create_app().app_context():
    insert(Scenario(id=0, name="Busunglück"))
    insert(Scenario(id=1, name="Autounfall"))
    insert(Scenario(id=3, name="Gasexplosion"))

    insert(Execution(id=1, scenario_id=0))
    insert(Execution(id=23456, scenario_id=1))

    insert(Location(id=0, name="RTW", picture_ref="rtw.jpg"))
    insert(Location(id=1, name="Rucksack", picture_ref="rucksack.jpg", location_id=0))
    insert(
        Location(
            id=2, name="Verbandskasten", picture_ref="Verbandskasten.jpg", location_id=1
        )
    )

    insert(Role(id=0, name="Passant", power=0))
    insert(Role(id=1, name="Rettungsanitäter", short_name="Sani", power=100))
    insert(Role(id=2, name="Rettungsassistent", short_name="Assistent", power=200))
    insert(Role(id=3, name="Notarzt", short_name="Arzt", power=300))

    insert(
        Player(
            tan="123ABC",
            execution_id=1,
            location_id=0,
            role_id=1,
            alerted=True,
            activation_delay_sec=120,
        )
    )
    insert(
        Player(
            tan="456DEF",
            execution_id=23456,
            location_id=0,
            role_id=2,
            alerted=True,
            activation_delay_sec=120,
        )
    )

    insert(Patient(id=0, name="Hans", injuries=(), activity_diagram=()))
    insert(Patient(id=1, name="Gisela", injuries=(), activity_diagram=()))

    insert(TakesPartIn(scenario_id=0, patient_id=0))
    insert(TakesPartIn(scenario_id=0, patient_id=1))

    insert(
        Resource(
            id=0, name="Verband", picture_ref="verband.jpg", quantity=10, location_id=2
        )
    )
    insert(
        Resource(
            id=1,
            name="Pflaster",
            picture_ref="pflaster.jpg",
            quantity=1000,
            location_id=2,
        )
    )
    insert(
        Resource(
            id=2,
            name="Stetoskop",
            picture_ref="stetoskop.jpg",
            quantity=2,
            location_id=1,
        )
    )
    insert(
        Resource(
            id=3, name="Knochensäge", picture_ref="saege.jpg", quantity=1, location_id=0
        )
    )

    insert(
        Action(
            id=0,
            name="Verband anlegen",
            required_power=100,
            picture_ref="verbandanlegen.jpg",
            results=(),
            duration_secs=60,
        )
    )
    insert(
        Action(
            id=1,
            name="Puls messen",
            required_power=100,
            picture_ref="pulsmessen.jpg",
            results=(),
            duration_secs=30,
        )
    )
    insert(
        Action(
            id=2,
            name="Pflaster aufkleben",
            required_power=0,
            picture_ref="pflaster.jpg",
            results=(),
            duration_secs=10,
        )
    )
    insert(
        Action(
            id=3,
            name="Amputation",
            required_power=300,
            picture_ref="pflaster.jpg",
            results=(),
            duration_secs=120,
        )
    )

    insert(ResourcesNeeded(action_id=0, resource_id=0))
    insert(ResourcesNeeded(action_id=1, resource_id=2))
    insert(ResourcesNeeded(action_id=2, resource_id=1))
    insert(ResourcesNeeded(action_id=3, resource_id=3))
    insert(WebUser(username="Terra", password=hashpw(b"pw1234", gensalt()).decode()))

    db.session.commit()
