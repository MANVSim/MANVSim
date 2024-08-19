from enum import IntEnum
from typing import List

from bcrypt import checkpw
from sqlalchemy import ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app_config import db


# -- Player --

class Role(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    short_name: Mapped[str] = mapped_column(nullable=True)
    power: Mapped[int] = mapped_column(nullable=False)


class Player(db.Model):
    tan: Mapped[str] = mapped_column(primary_key=True)
    execution_id: Mapped[int] = mapped_column(
        ForeignKey("execution.id"), nullable=False)
    location_id: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=False)
    role_id: Mapped[int] = mapped_column(ForeignKey("role.id"), nullable=False)
    alerted: Mapped[bool] = mapped_column(nullable=False)
    activation_delay_sec: Mapped[int] = mapped_column(nullable=False)

    execution: Mapped["Execution"] = relationship(back_populates="players")


# -- GAME --

class Scenario(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    executions: Mapped[List["Execution"]] = relationship(
        back_populates="scenario")


class Execution(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    scenario_id: Mapped[int] = mapped_column(
        ForeignKey("scenario.id"), nullable=False)
    scenario: Mapped["Scenario"] = relationship(back_populates="executions")
    players: Mapped[List["Player"]] = relationship(back_populates="execution")
    name: Mapped[str] = mapped_column(nullable=False)


class Patient(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    # If no location is set, one is generated at runtime
    location: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=True)
    activity_diagram = db.Column(db.JSON(), nullable=False)


class TakesPartIn(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    quantity: Mapped[int] = mapped_column(default=1, nullable=False)
    scenario_id: Mapped[int] = mapped_column(
        ForeignKey("scenario.id"), nullable=False)
    patient_id: Mapped[int] = mapped_column(
        ForeignKey("patient.id"), nullable=False)


# -- Scenario-Data --

class Location(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    media_refs = db.Column(db.JSON(), nullable=True)
    is_vehicle: Mapped[bool] = mapped_column(default=False, nullable=False)

    quantities_in_scenario = relationship("LocationQuantityInScenario",
                                          back_populates="location")

    # Relationship to manage child locations (all locations contained within this one)
    children = relationship(
        "Location",
        secondary="location_contains_location",
        primaryjoin="Location.id == LocationContainsLocation.parent",
        secondaryjoin="Location.id == LocationContainsLocation.child",
        back_populates="parents"
    )

    # Relationship to manage parent locations (all locations that contain this one)
    parents = relationship(
        "Location",
        secondary="location_contains_location",
        primaryjoin="Location.id == LocationContainsLocation.child",
        secondaryjoin="Location.id == LocationContainsLocation.parent",
        back_populates="children"
    )


class LocationContainsLocation(db.Model):
    """
    Allows templating of locations. Meaning: a backpack can be stored in two
    locations. The copy instances will be generated while loading the game
    state in memory.
    """
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    parent: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=False)
    child: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=False)


class LocationQuantityInScenario(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    quantity: Mapped[int] = mapped_column(nullable=False, default=1)
    scenario_id: Mapped[int] = mapped_column(
        ForeignKey("scenario.id"), nullable=False)
    location_id: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=False)

    location = relationship("Location",
                            back_populates="quantities_in_scenario")


class PlayersToVehicleInExecution(db.Model):
    execution_id: Mapped[int] = mapped_column(ForeignKey("execution.id"),
                                              primary_key=True,
                                              nullable=False)
    player_id: Mapped[str] = mapped_column(ForeignKey("player.tan"),
                                           nullable=False, primary_key=True)
    location_id: Mapped[int] = mapped_column(ForeignKey("location.id"), nullable=False)
    vehicle_name: Mapped[str] = mapped_column(nullable=False)

    __table_args__ = (
        UniqueConstraint("execution_id", "vehicle_name", name="unique_execution_vehicle"),
    )


class Resource(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    media_refs = db.Column(db.JSON(), nullable=True)
    consumable: Mapped[bool] = mapped_column(nullable=False)
    quantities_in_location = relationship("ResourceInLocation",
                                          back_populates="resource")


class ResourceInLocation(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    quantity: Mapped[int] = mapped_column(nullable=False)
    location_id: Mapped[int] = mapped_column(
        ForeignKey("location.id"), nullable=False)
    resource_id: Mapped[int] = mapped_column(
        ForeignKey("resource.id"), nullable=False)
    resource = relationship("Resource",
                            back_populates="quantities_in_location")


class ResourcesNeeded(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    action_id: Mapped[int] = mapped_column(
        ForeignKey("action.id"), nullable=False)
    resource_id: Mapped[int] = mapped_column(
        ForeignKey("resource.id"), nullable=False)


class Action(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(nullable=False)
    required_power: Mapped[int] = mapped_column(nullable=False)
    media_refs = db.Column(db.JSON(), nullable=True)
    duration_secs: Mapped[int] = mapped_column(nullable=False)
    results: Mapped[str] = mapped_column(nullable=False)


class LoggedEvent(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    execution: Mapped[int] = mapped_column(nullable=False)
    time: Mapped[int] = mapped_column(nullable=False)
    type: Mapped[str] = mapped_column(nullable=False)
    data = db.Column(db.JSON(), nullable=False)


# -- Web --

# pyright: reportAttributeAccessIssue=false
class WebUser(db.Model):

    class Role(IntEnum):
        """
        Defines all Roles a User could have where the value of each role is its
        assigned power, which establishes an order between all roles.
        """
        WEB_ADMIN = 9999  # Web Application Administrator
        SCENARIO_ADMIN = 100  # Scenario Editor/Creator
        GAME_MASTER = 50  # Execution Management
        READ_ONLY = 0

        def __eq__(self, other):
            if isinstance(other, Role):
                return self.value == other.value
            return NotImplemented

        def __lt__(self, other):
            if isinstance(other, Role):
                return self.value < other.value
            return NotImplemented

        @classmethod
        def from_string(cls, role_name: str):
            """
            Converts a string to the corresponding Role object.
            """
            try:
                return cls[role_name.upper()]
            except KeyError:
                raise ValueError(f"No Role found for name: {role_name}")


    username: Mapped[str] = mapped_column(primary_key=True)
    password: Mapped[str]
    role: Mapped[str] = mapped_column(nullable=False)

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return self.username

    @staticmethod
    def get_by_username(username: str) -> "WebUser | None":
        return db.session.execute(db.select(WebUser).where(
            WebUser.username == username)).scalar_one_or_none()

    def check_password(self, password: str) -> bool:
        return checkpw(str.encode(password), self.password.encode())
