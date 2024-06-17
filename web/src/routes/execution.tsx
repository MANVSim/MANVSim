import { Card, Container } from "react-bootstrap"
import QRCode from "react-qr-code"
import { useParams } from "react-router"
import { isType } from "../utils"
import { useEffect, useState } from "react"
import { getExecutionStatus } from "../api"
import _ from "lodash"

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
  name: string,
  status: string,
  action: string
}

interface ExecutionData {
  id: number,
  status: string,
  players: Player[]
}

function isExecutionData(obj: object): obj is ExecutionData {
  return isType<ExecutionData>(obj, "players", "status", "id")
}

function PlayerStatus({ player }: { player: Player }) {
  return (
    <tr>
      <td>{player.tan}</td>
      <td>{player.status}</td>
      <td>{player.name}</td>
      <td>{player.action}</td>
    </tr>
  )
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

  const [tansAvailable, setTansAvailable] = useState<Player[]>([])
  const [tansUsed, setTansUsed] = useState<Player[]>([])
  useEffect(() => {
    if (execution === null) return
    const [newTansAvailable, newTansUsed] = _.partition(execution.players, x => x.status === "")
    setTansAvailable(newTansAvailable)
    setTansUsed(newTansUsed)
  }, [execution])

  return (
    <div>
      {execution &&
        <div>
          <h2>Ausführung</h2>
          <p>ID: {execution.id}</p>
          <p>Verfübare TANs:</p>
          <Container fluid className="d-flex flex-wrap">
            {tansAvailable.map(player => <TanCard key={player.tan} tan={player.tan} />)}
          </Container>
          <table className="table mt-5">
            <thead>
              <tr>
                <th>TAN</th>
                <th>Status</th>
                <th>Name</th>
                <th>Maßnahme</th>
              </tr>
            </thead>
            <tbody>
              {tansUsed.map(player => <PlayerStatus player={player} />)}
            </tbody>
          </table>
        </div>
      }
    </div>
  )
}
