import { ReactElement } from "react"
import { ActionFunctionArgs, useLoaderData } from "react-router"
import ListGroup from "react-bootstrap/ListGroup"
import PatientEntry from "../components/PatientEntry"
import { PatientResponse } from "../types"
import { getPatients, tryFetchApi } from "../api"

export default function PatientsRoute(): ReactElement {
  const patients = useLoaderData() as PatientResponse[]

  return (
    <div>
      <h1>Patienten</h1>
      <div className="mb-3">Die folgenden Patienten sind verfügbar:</div>
      <ListGroup>
        {patients.map(
          (p: PatientResponse): ReactElement => (
            <PatientEntry patient={p} key={p.id} />
          ),
        )}
        <ListGroup.Item>Neu</ListGroup.Item>
      </ListGroup>
    </div>
  )
}

PatientsRoute.loader = async function (): Promise<PatientResponse[]> {
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
