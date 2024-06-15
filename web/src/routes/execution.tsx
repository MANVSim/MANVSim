import { Card, Container } from "react-bootstrap"
import QRCode from "react-qr-code"
import { useLocation } from "react-router"

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

interface LocationStateData {
  id: number,
  tans: string[]
}

function isLocationStateData(obj: unknown): obj is LocationStateData {
  if (typeof obj !== "object") return false
  const t = obj as LocationStateData
  return t.id !== undefined && t.tans !== undefined
}

export default function Execution() {
  const { state } = useLocation()

  if (!isLocationStateData(state)) {
    throw Error("The location data for the execution is in the wrong format")
  }
  return (
    <div>
      <h2>Ausführung</h2>
      <p>ID: {state.id}</p>
      <p>TANs:</p>
      <Container fluid className="d-flex flex-wrap">
        {state.tans.map(t => <TanCard key={t} tan={t} />)}
      </Container>
    </div>
  )
}
