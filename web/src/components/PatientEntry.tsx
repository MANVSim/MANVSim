import Button from "react-bootstrap/Button"
import ListGroup from "react-bootstrap/ListGroup"
import Stack from "react-bootstrap/Stack"
import { Patient } from "../types"
import { ReactElement } from "react"

interface PatientEntryProps {
  patient: Patient
}

export default function PatientEntry({
  patient,
}: PatientEntryProps): ReactElement {
  return (
    <ListGroup.Item>
      <Stack direction="horizontal" gap={1}>
        <div className="me-auto">{patient.name}</div>
        <Button>Bearbeiten</Button>
        <Button variant="danger">Löschen</Button>
      </Stack>
    </ListGroup.Item>
  )
}
