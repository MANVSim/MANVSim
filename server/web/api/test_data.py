from random import choice
from utils.tans import uniques

test_tans = [str(x) for x in uniques(5)]

test_execution = {
    "id": -1,
    "status": "",
    "players": [
        {
            "tan": x,
            "name": "Max Mustermann",
            "status": choice(["", "In Vorbereitung"]),
            "action": "Legt Zugang",
        }
        for x in test_tans
    ],
}
