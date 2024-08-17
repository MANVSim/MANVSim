import Button from "react-bootstrap/Button"
import ListGroup from "react-bootstrap/ListGroup"
import Stack from "react-bootstrap/Stack"
import { PatientResponse } from "../types"
import { ReactElement } from "react"
import { CsrfForm } from "./CsrfForm"

interface PatientEntryProps {
  patient: PatientResponse
}

export default function PatientEntry({
  patient,
}: PatientEntryProps): ReactElement {
  return (
    <ListGroup.Item>
      <Stack direction="horizontal" gap={1}>
        <div className="me-auto">{patient.name}</div>
        <Button role="link" href={`/patient/${patient.id}`}>
          Bearbeiten
        </Button>
        <CsrfForm method="POST">
          <Button variant="danger" type="submit" name="id" value={patient.id}>
            Löschen
          </Button>
        </CsrfForm>
      </Stack>
    </ListGroup.Item>
  )
}
