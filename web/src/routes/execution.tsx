import { Button, Card, Container, Form } from "react-bootstrap"
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
} from "../types"
import CsrfForm from "../components/CsrfForm"
import { useSubmit } from "react-router-dom"
import { changeExecutionStatus, getExecution, togglePlayerStatus } from "../api"

function TanCard({ tan }: { tan: string }): ReactElement {
  return (
    <Card className="d-flex m-1">
      <QRCode value={tan} className="align-self-center p-3" />
      <Card.Body>
        <Card.Title className="text-center">{tan}</Card.Title>
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
    <div className="mt-5">
      <CsrfForm method="POST" onChange={(e) => submit(e.currentTarget)}>
        <input type="hidden" name="id" value="change-status" />
        <Form.Label>Status</Form.Label>
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

  const [tansAvailable, tansUsed] = _.partition(
    execution?.players,
    (): boolean => false, // TODO: Determine if TAN is used or not
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
          <p>ID: {execution.id}</p>
          <h3>Verfügbare TANs:</h3>
          <Container fluid className="d-flex flex-wrap">
            {tansAvailable.map((player) => (
              <TanCard key={player.tan} tan={player.tan} />
            ))}
          </Container>
          <Status execution={execution} />
          <h3 className="mt-5">Aktive TANs:</h3>
          <table className="table">
            <thead>
              <tr>
                <th>TAN</th>
                <th>Status</th>
                <th>Name</th>
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
  if (id === "change-status") {
    return changeExecutionStatus(params.executionId, formData)
  } else if (id === "player-status") {
    const playerTan = formData.get("tan") as string | null
    if (playerTan === null) return null
    formData.delete("tan")
    return togglePlayerStatus(params.executionId, playerTan, formData)
  }
  return null
}
