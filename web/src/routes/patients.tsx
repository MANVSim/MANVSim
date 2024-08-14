import { ReactElement } from "react"
import { useLoaderData } from "react-router"
import ListGroup from "react-bootstrap/ListGroup"
import Button from "react-bootstrap/Button"
import { Stack } from "react-bootstrap"

interface Patient {
  id: number
  name: string
}

interface PatientEntryProps {
  patient: Patient
}

function PatientEntry({ patient }: PatientEntryProps): ReactElement {
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

export default function PatientsRoute(): ReactElement {
  const patients = useLoaderData() as Patient[]
  return (
    <div>
      <div className="mb-3">Die folgenden Patienten sind verfügbar:</div>
      <ListGroup>
        {patients.map(
          (p: Patient): ReactElement => (
            <PatientEntry patient={p} key={p.id} />
          ),
        )}
        <ListGroup.Item>Neu</ListGroup.Item>
      </ListGroup>
    </div>
  )
}

PatientsRoute.loader = async function (): Promise<Patient[]> {
  const response = await fetch("/web/patient")
  const json = await response.json()
  return json
}
