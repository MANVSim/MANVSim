import { ReactElement } from "react"
import { ActionFunctionArgs, useLoaderData } from "react-router"
import ListGroup from "react-bootstrap/ListGroup"
import PatientEntry from "../components/PatientEntry"
import { Patient } from "../types"
import { getPatients, tryFetchApi } from "../api"

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
  return await getPatients()
}

PatientsRoute.action = async function ({
  request,
}: ActionFunctionArgs): Promise<null> {
  const formData = await request.formData()
  tryFetchApi(`patient/${formData.get("id")}`, {
    method: "DELETE",
    body: formData,
  })
  return null
}
