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
  ExecutionStatusEnum,
  Role,
  Location,
} from "../types"
import CsrfForm from "../components/CsrfForm"
import { useSubmit } from "react-router-dom"
import { changeExecutionStatus, getExecution, togglePlayerStatus, createNewPlayer, } from "../api"

function TanCard({ player }: { player: Player }): ReactElement {
  return (
    <Card className="d-flex m-1">
      <QRCode value={player.tan} className="align-self-center p-3 w-100" />
      <Card.Body>
        <Card.Title className="text-center">{player.tan}</Card.Title>
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

function Status({ execution }: { execution: ExecutionData }): ReactElement {
  const submit = useSubmit()
  const [status, setStatus] = useState(execution.status)
  useEffect(() => {
    setStatus(execution.status)
  }, [execution])

  return (
    <div>
      <h3>Status</h3>
      <CsrfForm method="POST" onChange={(e) => submit(e.currentTarget)}>
        <input type="hidden" name="id" value="change-status" />
        <Form.Select
          name="new_status"
          value={status}
          onChange={(e) =>
            setStatus(
              ExecutionStatusEnum.safeParse(e.currentTarget.value).data ||
              "UNKNOWN",
            )
          }
        >
          <option value="PENDING">Vorbereitung</option>
          <option value="RUNNING">Laufend</option>
          <option value="FINISHED">Beendet</option>
          {execution.status === "UNKNOWN" && (
            <option value="UNKNOWN" disabled>
              Unbekannt
            </option>
          )}
        </Form.Select>
      </CsrfForm>
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
          <h2>Ausführung</h2>
          <p>ID: {executionId}</p>
          <Status execution={execution} />
          <h3>Verfügbare TANs:</h3>
          <Container fluid className="d-flex flex-wrap my-3">
            {tansAvailable.map((player) => (
              <TanCard key={player.tan} player={player} />
            ))}
          </Container>
          <div className="d-grid border rounded">
            <Button className="rounded-top" onClick={() => setOpen(!open)}>
              {open ? "Schließen" : "Weiteren Spieler hinzufügen"}
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
    case "change-status":
      return changeExecutionStatus(params.executionId, formData)
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
