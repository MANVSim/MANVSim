from sqlalchemy import select, desc

import models
from app_config import db
from utils.tans import unique


def add_vehicles_to_execution_to_session(
    execution_id: int | None, scenario_id: int,
    vehicle_id: int, vehicle_name: str, travel_time: int
):
    role_query = (select(models.Role.id, models.Role.power)
                  .order_by(desc(models.Role.power)))
    highest_role = db.session.execute(role_query).first()
    tan = str(unique())
    player = (models.Player(
        tan=tan, # type: ignore
        execution_id=execution_id if execution_id != 0 else None,  # type: ignore
        location_id=vehicle_id,  # type: ignore
        role_id=highest_role[0],  # type: ignore
        alerted=False)  # type: ignore
    )
    db.session.add(player)

    vehicle = models.PlayersToVehicleInExecution(
        execution_id=execution_id if execution_id != 0 else None,  # type: ignore
        scenario_id=scenario_id,  # type: ignore
        location_id=vehicle_id,  # type: ignore
        vehicle_name=vehicle_name,  # type: ignore
        player_tan=tan,  # type: ignore
        travel_time=travel_time  # type: ignore
    )
    db.session.add(vehicle)
