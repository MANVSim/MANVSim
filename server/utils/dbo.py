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
        tan=tan,
        execution_id=execution_id if execution_id != 0 else None,  # FK
        location_id=vehicle_id,
        role_id=highest_role[0],
        alerted=False)
    )
    db.session.add(player)

    vehicle = models.PlayersToVehicleInExecution(
        execution_id=execution_id if execution_id != 0 else None,  # FK
        scenario_id=scenario_id,
        location_id=vehicle_id,
        vehicle_name=vehicle_name,
        player_tan=tan,
        travel_time=travel_time
    )
    db.session.add(vehicle)
