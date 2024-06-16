import { Card, Container } from "react-bootstrap"
import QRCode from "react-qr-code"
import { useParams } from "react-router"
import { isType } from "../utils"
import { useEffect, useState } from "react"
import { getExecutionStatus } from "../api"

function TanCard({ tan }: { tan: string }) {
  return (
    <Card className="d-flex m-1">
      <QRCode value={tan} className="align-self-center p-3" />
      <Card.Body>
        <Card.Title className="text-center">{tan}</Card.Title>
      </Card.Body>
    </Card >
  )
}

interface Player {
  tan: string,
  status: string
}

interface ExecutionData {
  id: number,
  status: string,
  players: Player[]
}

function isExecutionData(obj: object): obj is ExecutionData {
  return isType<ExecutionData>(obj, "players", "status", "id")
}

export default function Execution() {
  const [execution, setExecution] = useState<null | ExecutionData>(null)
  const { executionId } = useParams<{ executionId: string }>()
  useEffect(() => {
    const intervalId = setInterval(async () => {
      if (typeof executionId === "undefined") return
      const status = await getExecutionStatus(executionId)
      if (isExecutionData(status)) {
        setExecution(status)
      }
    }, 5000)
    return () => clearInterval(intervalId)
  })

  return (
    <div>
      {execution &&
        <div>
          <h2>Ausführung</h2>
          <p>ID: {execution.id}</p>
          <p>TANs:</p>
          <Container fluid className="d-flex flex-wrap">
            {execution.players.map(player => <TanCard key={player.tan} tan={player.tan} />)}
          </Container>
        </div>
      }
    </div>
  )
}
