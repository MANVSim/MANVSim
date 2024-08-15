import { ReactElement } from "react"
import { useLoaderData } from "react-router"
import ListGroup from "react-bootstrap/ListGroup"
import PatientEntry from "../components/PatientEntry"
import { Patient, isPatient } from "../types"

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
  if (
    !Array.isArray(json) ||
    json.some((p: unknown): boolean => !isPatient(p))
  ) {
    throw new Error(
      "Request to /web/patient did not return an array of patients",
    )
  }
  return json
}
