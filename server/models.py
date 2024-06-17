from app import db
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column


# just a dummy model
#
# can be created like this:
#
# user = User(name="foo")
# db.session.add(user)
# db.session.commit()


class Scenario(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)


class Execution(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    scenario_id: Mapped[int] = mapped_column(ForeignKey("scenario.id"), nullable=False)


class Location(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    picture_ref: Mapped[str] = mapped_column(nullable=False)
    location_id: Mapped[int] = mapped_column(ForeignKey("location.id"), nullable=True)


class Role(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    short_name: Mapped[str] = mapped_column(nullable=True)
    power: Mapped[int] = mapped_column(nullable=False)


class Player(db.Model):
    tan: Mapped[str] = mapped_column(primary_key=True)
    execution_id: Mapped[int] = mapped_column(
        ForeignKey("execution.id"), nullable=False
    )
    location_id: Mapped[int] = mapped_column(ForeignKey("location.id"), nullable=False)
    role_id: Mapped[int] = mapped_column(ForeignKey("role.id"), nullable=False)
    alerted: Mapped[bool] = mapped_column(nullable=False)
    activation_delay_sec: Mapped[int] = mapped_column(nullable=False)


class Patient(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    location: Mapped[int] = mapped_column(ForeignKey("location.id"), nullable=False)
    injuries = db.Column(db.JSON(), nullable=False)
    activity_diagram = db.Column(db.JSON(), nullable=False)


class TakesPartIn(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    scenario_id: Mapped[int] = mapped_column(ForeignKey("scenario.id"), nullable=False)
    patient_id: Mapped[int] = mapped_column(ForeignKey("patient.id"), nullable=False)


class Resource(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    picture_ref: Mapped[str] = mapped_column(nullable=False)
    quantity: Mapped[int] = mapped_column(nullable=False)
    location_id: Mapped[int] = mapped_column(ForeignKey("location.id"), nullable=False)


class Action(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    required_power: Mapped[int] = mapped_column(nullable=False)
    picture_ref: Mapped[str] = mapped_column(nullable=False)
    duration_secs: Mapped[int] = mapped_column(nullable=False)
    results = db.Column(db.JSON(), nullable=False)


class ResourcesNeeded(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    action_id: Mapped[int] = mapped_column(ForeignKey("action.id"), nullable=False)
    resource_id: Mapped[int] = mapped_column(ForeignKey("resource.id"), nullable=False)
