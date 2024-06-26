import { Button, Card, Container } from "react-bootstrap"
import QRCode from "react-qr-code"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
  useParams,
} from "react-router"
import { ReactElement, useEffect, useState } from "react"
import {
  getExecutionStatus,
  startExecution,
  stopExecution,
  togglePlayerStatus,
} from "../api"
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
          </Button>
        </CsrfForm>
      </td>
      <td>{player.name}</td>
    </tr>
  )
}

function ToggleExecution({
  execution,
}: {
  execution: ExecutionData
}): ReactElement {
  const executionActive = execution.status === ExecutionStatusEnum.enum.RUNNING
  return (
    <div className="mt-5">
      <CsrfForm method="POST">
        <input type="hidden" name="id" value="toggle-execution" />
        <Button
          name="toggle"
          value={executionActive ? "stop" : "start"}
          type="submit"
        >
          {executionActive ? "Beenden" : "Starten"}
        </Button>
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
      const status = await getExecutionStatus(executionId)
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
          <ToggleExecution execution={execution} />
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
  return getExecutionStatus(executionId)
}

Execution.action = async function ({ params, request }: ActionFunctionArgs) {
  if (params.executionId === undefined) return null
  const formData = await request.formData()
  const id = formData.get("id")
  formData.delete("id")
  if (id === "toggle-execution") {
    const fExec =
      formData.get("toggle") === "start" ? startExecution : stopExecution
    return fExec(params.executionId, formData)
  } else if (id === "player-status") {
    const playerTan = formData.get("tan") as string | null
    if (playerTan === null) return null
    formData.delete("tan")
    return togglePlayerStatus(params.executionId, playerTan, formData)
  }
  return null
}
