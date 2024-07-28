import { useSubmit } from "react-router-dom"
import { Player } from "../types"
import { CsrfForm } from "./CsrfForm"
import { Button } from "react-bootstrap"
import "./PlayerStatus.css"

export type PlayerStatusProps = {
  player: Player
}

export function PlayerStatus({ player }: PlayerStatusProps) {
  const submit = useSubmit()
  return (
    <tr>
      <td>{player.tan}</td>
      <td>
        {player.logged_in ? (
          player.alerted ? (
            "Alarmiert"
          ) : (
            <div className="d-flex align-items-center">
              <div className="px-2">Bereit</div>
              <CsrfForm
                onChange={(event) => submit(event.currentTarget)}
                method="POST"
              >
                <input type="hidden" name="id" value="player-status" />
                <input type="hidden" name="tan" value={player.tan} />
                <Button
                  id={"toggle-status-" + player.tan}
                  name="alerted"
                  type="submit"
                  value={Number(player.alerted)}
                  title="Zum Alarmieren klicken"
                >
                  Alarmieren
                </Button>{" "}
              </CsrfForm>
            </div>
          )
        ) : (
          "Nicht eingeloggt"
        )}
      </td>
      <td>{player.name}</td>
      <td>{player.role?.name ?? "Unbekannt"}</td>
      <td>{player.location?.name ?? "Unbekannt"}</td>
    </tr>
  )
}
