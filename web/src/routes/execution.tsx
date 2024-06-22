import { Button, Card, Container } from "react-bootstrap"
import QRCode from "react-qr-code"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useActionData,
  useLoaderData,
  useParams,
} from "react-router"
import { ReactElement, useEffect, useState } from "react"
import { getExecutionStatus, startExecution, stopExecution } from "../api"
import _ from "lodash"
import { config } from "../config"
import { Form } from "react-router-dom"
import { CsrfInput } from "../contexts/csrf"
import {
  Player,
  ExecutionData,
  isExecutionData,
  ExecutionStatusEnum,
} from "../types"

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
  return (
    <tr>
      <td>{player.tan}</td>
      <td>{player.status}</td>
      <td>{player.name}</td>
      <td>{player.action}</td>
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
      <Form method="POST">
        <CsrfInput />
        <Button
          name="toggle"
          value={executionActive ? "stop" : "start"}
          type="submit"
        >
          {executionActive ? "Beenden" : "Starten"}
        </Button>
      </Form>
    </div>
  )
}

export default function Execution(): ReactElement {
  const loaderData = useLoaderData()
  const actionData = useActionData()

  useEffect(() => {
    if (isExecutionData(actionData)) {
      setExecution(actionData)
    }
  }, [actionData])

  const [execution, setExecution] = useState<null | ExecutionData>(
    isExecutionData(loaderData) ? loaderData : null,
  )

  const { executionId } = useParams<{ executionId: string }>()

  useEffect(() => {
    const intervalId = setInterval(async () => {
      if (typeof executionId === "undefined") return
      const status = await getExecutionStatus(executionId)
      if (isExecutionData(status)) {
        setExecution(status)
      }
    }, config.pollingRate)
    return () => clearInterval(intervalId)
  })

  const [tansAvailable, tansUsed] = _.partition(
    execution?.players,
    (player: Player): boolean => player.status === "",
  )

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
                <th>Maßnahme</th>
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
  console.log(formData)

  if (formData.get("toggle") === "start") {
    return startExecution(params.executionId, formData)
  } else {
    return stopExecution(params.executionId, formData)
  }
}
