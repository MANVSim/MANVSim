import "./execution.css"
import {
  Button,
  Card,
  Collapse,
  Container,
  FloatingLabel,
  Form,
} from "react-bootstrap"
import QRCode from "react-qr-code"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
  useParams,
} from "react-router"
import { ReactElement, useEffect, useState } from "react"
import _ from "lodash"
import { config } from "../config"
import {
  Player,
  ExecutionData,
  isExecutionData,
  Role,
  Location,
} from "../types"
import CsrfForm from "../components/CsrfForm"
import { useSubmit } from "react-router-dom"
import { changeExecutionStatus, getExecution, togglePlayerStatus, createNewPlayer, } from "../api"

function TanCard({ player }: { player: Player }): ReactElement {
  const [toggle, setToggle] = useState(true)
  return (
    <Card className="d-flex m-1">
      <Button className={`btn-light btn-sm ${toggle ? "" : "d-none"}`} onClick={() => setToggle(!toggle)}>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-down-fill" viewBox="0 0 16 16">
          <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
        </svg>
      </Button>
      <Button className={`btn-light btn-sm ${toggle ? "d-none" : ""}`} onClick={() => setToggle(!toggle)}>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-up-fill" viewBox="0 0 16 16">
          <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
        </svg>
      </Button>
      <QRCode value={player.tan} className={`text-center align-self-center p-3 w-100 ${toggle ? "d-none" : ""}`} />
      <Card.Body>
        <Card.Title className={`text-center ${toggle ? "d-none" : ""}`}>{player.tan}</Card.Title>
        <div>Rolle: {player.role?.name ?? "Unbekannt"}</div>
        <div>Ort: {player.location?.name ?? "Unbekannt"}</div>
      </Card.Body>
    </Card>
  )
}

function PlayerStatus({ player }: { player: Player }): ReactElement {
  const submit = useSubmit()
  return (
    <tr>
      <td>{player.tan}</td>
      <td>
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
            title="Zum Ändern klicken"
          >
            {player.alerted ? "Alarmiert" : "Bereit"}
          </Button>{" "}
        </CsrfForm>
      </td>
      <td>{player.name}</td>
      <td>{player.role?.name ?? "Unbekannt"}</td>
      <td>{player.location?.name ?? "Unbekannt"}</td>
    </tr>
  )
}
// FIXME hier müsste n anderer Typ hin. Ich bin nur  gerade zu blöd. Iwas mit dem ExecutionStatusEnum
function StatusIcon({ status }: any) {
  let icon;

  switch (status) {
    case 'PENDING':
      icon = (
        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="orange" className="bi bi-slash-circle-fill" viewBox="0 0 16 16">
          <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-4.646-2.646a.5.5 0 0 0-.708-.708l-6 6a.5.5 0 0 0 .708.708z" />
        </svg>
      );
      break;
    case 'RUNNING':
      icon = (
        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="green" className="bi bi-circle-fill" viewBox="0 0 16 16">
          <circle cx="8" cy="8" r="8" />
        </svg>
      );
      break;
    case 'FINISHED':
      icon = (
        <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="red" className="bi bi-sign-stop-fill" viewBox="0 0 16 16">
          <path d="M10.371 8.277v-.553c0-.827-.422-1.234-.987-1.234-.572 0-.99.407-.99 1.234v.553c0 .83.418 1.237.99 1.237.565 0 .987-.408.987-1.237m2.586-.24c.463 0 .735-.272.735-.744s-.272-.741-.735-.741h-.774v1.485z" />
          <path d="M4.893 0a.5.5 0 0 0-.353.146L.146 4.54A.5.5 0 0 0 0 4.893v6.214a.5.5 0 0 0 .146.353l4.394 4.394a.5.5 0 0 0 .353.146h6.214a.5.5 0 0 0 .353-.146l4.394-4.394a.5.5 0 0 0 .146-.353V4.893a.5.5 0 0 0-.146-.353L11.46.146A.5.5 0 0 0 11.107 0zM3.16 10.08c-.931 0-1.447-.493-1.494-1.132h.653c.065.346.396.583.891.583.524 0 .83-.246.83-.62 0-.303-.203-.467-.637-.572l-.656-.164c-.61-.147-.978-.51-.978-1.078 0-.706.597-1.184 1.444-1.184.853 0 1.386.475 1.436 1.087h-.645c-.064-.32-.352-.542-.797-.542-.472 0-.77.246-.77.6 0 .261.196.437.553.522l.654.161c.673.164 1.06.487 1.06 1.11 0 .736-.574 1.228-1.544 1.228Zm3.427-3.51V10h-.665V6.57H4.753V6h3.006v.568H6.587Zm4.458 1.16v.544c0 1.131-.636 1.805-1.661 1.805-1.026 0-1.664-.674-1.664-1.805V7.73c0-1.136.638-1.807 1.664-1.807s1.66.674 1.66 1.807ZM11.52 6h1.535c.82 0 1.316.55 1.316 1.292 0 .747-.501 1.289-1.321 1.289h-.865V10h-.665V6.001Z" />
        </svg>
      );
      break;
    default:
      icon = null;
  }

  return (icon);
}


function Status({ execution }: { execution: ExecutionData }): ReactElement {
  const [status, setStatus] = useState(execution.status)
  useEffect(() => {
    setStatus(execution.status)
  }, [execution])

  return (
    <div>
      <div className="d-flex mt-5">
        <span className="fs-4">
          Aktueller Status:
        </span>
        <div className="d-flex ms-3 align-items-center">
          <StatusIcon status={status} />
        </div>
        <div className="ms-auto ms-3">
          <Button className={
            `${status == "UNKNOWN" || status == "FINISHED" ? "" : "d-none"} btn-success`
          } onClick={() => {
            setStatus("PENDING")
            changeExecutionStatus(execution.id, "PENDING")
          }}>Aktivieren</Button>
          <Button className={`${status == "PENDING" ? "" : "d-none"}`} onClick={() => {
            setStatus("RUNNING")
            changeExecutionStatus(execution.id, "RUNNING")
          }}>Starten</Button>
          <Button className={
            `${status == "RUNNING" ? "" : "d-none"} btn-warning`
          } onClick={() => {
            setStatus("PENDING")
            changeExecutionStatus(execution.id, "PENDING")
          }}>Pause</Button>
          <Button className={
            `${status == "RUNNING" ? "" : "d-none"} btn-danger ms-2`
          } onClick={() => {
            setStatus("FINISHED")
            changeExecutionStatus(execution.id, "FINISHED")
          }}>Stoppen</Button>
        </div>
      </div>
    </div>
  )
}

export default function Execution(): ReactElement {
  const loaderData = useLoaderData()
  const [execution, setExecution] = useState<null | ExecutionData>(
    isExecutionData(loaderData) ? loaderData : null,
  )

  const [open, setOpen] = useState(false)

  const [tansAvailable, tansUsed] = _.partition(
    execution?.players,
    (player: Player): boolean => player.name === null,
  )

  const { executionId } = useParams<{ executionId: string }>()

  useEffect(() => {
    if (isExecutionData(loaderData)) {
      setExecution(loaderData)
    }
  }, [loaderData])

  useEffect(() => {
    const intervalId = setInterval(async () => {
      if (typeof executionId === "undefined") return
      const status = await getExecution(executionId)
      if (isExecutionData(status)) {
        setExecution(status)
      }
    }, config.pollingRate)
    return () => clearInterval(intervalId)
  }, [executionId])

  return (
    <div>
      {execution ? (
        <div>
          <h2 id="execution-name-header" className="align-self-center mt-3">{execution.name}-{executionId}</h2>
          <Status execution={execution} />
          <div className="d-grid border rounded mt-3">
            <Button className={`rounded ${open ? "btn-light" : "btn-primary"}`} onClick={() => setOpen(!open)}>
              {open ?
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-caret-up-fill" viewBox="0 0 16 16">
                  <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                </svg>
                : "Weiteren Spieler hinzufügen"}
            </Button>
            <Collapse in={open}>
              <div>
                <CsrfForm method="POST" className="d-grid gap-2 p-3">
                  <input type="hidden" name="id" value="new-player" />
                  <FloatingLabel label="Rolle">
                    <Form.Select name="role">
                      {execution.roles.map((role: Role) => {
                        return (
                          <option key={role.id} value={role.id}>
                            {role.name}
                          </option>
                        )
                      })}
                    </Form.Select>
                  </FloatingLabel>
                  <FloatingLabel label="Ort">
                    <Form.Select name="location">
                      {execution.locations.map((location: Location) => {
                        return (
                          <option key={location.id} value={location.id}>
                            {location.name}
                          </option>
                        )
                      })}
                    </Form.Select>
                  </FloatingLabel>
                  <Button type="submit">Neuen Spieler erstellen</Button>
                </CsrfForm>
              </div>
            </Collapse>
          </div>
          <h3>Verfügbare TANs:</h3>
          <Container fluid className="d-flex flex-wrap my-3">
            {tansAvailable.length ? (tansAvailable.map((player) => (
              <TanCard key={player.tan} player={player} />
            ))
            ) : (
              <span>Erstelle neue Spieler um neue Tans verfügbar zu haben.</span>
            )
            }
          </Container>
          <h3 className="mt-5">Aktive TANs:</h3>
          <table className="table">
            <thead>
              <tr>
                <th>TAN</th>
                <th>Status</th>
                <th>Name</th>
                <th>Rolle</th>
                <th>Ort</th>
              </tr>
            </thead>
            <tbody>
              {tansUsed.map((player) => (
                <PlayerStatus key={player.tan} player={player} />
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div>Loading...</div>
      )}
    </div>
  )
}

Execution.loader = async function ({
  params: { executionId },
}: LoaderFunctionArgs) {
  if (executionId === undefined) return null
  return getExecution(executionId)
}

Execution.action = async function ({ params, request }: ActionFunctionArgs) {
  if (params.executionId === undefined) return null
  const formData = await request.formData()
  const id = formData.get("id")
  formData.delete("id")

  switch (id) {
    case "player-status": {
      const playerTan = formData.get("tan") as string | null
      if (playerTan === null) return null
      formData.delete("tan")
      return togglePlayerStatus(params.executionId, playerTan, formData)
    }
    case "new-player":
      return createNewPlayer(params.executionId, formData)
    default:
      throw new Error(`Case '${id}' is not covered in Execution.action`)
  }
}
