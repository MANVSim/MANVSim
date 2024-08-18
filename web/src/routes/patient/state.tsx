import { ReactElement } from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getPatient } from "../../api"
import { Patient, PatientResponse, State } from "../../types"
import { ListGroup } from "react-bootstrap"

export default function StateRoute(): ReactElement {
  const patient = useLoaderData() as Patient
  return (
    <div>
      <ListGroup>
        {Object.values(patient.activity_diagram.states).map((state: State) => (
          <div>{state.uuid}</div>
        ))}
      </ListGroup>
    </div>
  )
}

StateRoute.loader = async function ({
  params,
}: LoaderFunctionArgs): Promise<PatientResponse> {
  const id = params.patientId
  if (id === undefined) {
    throw new Error("No patient ID provided")
  }
  const patient = await getPatient(id)
  if (patient.activity_diagram !== undefined) {
    patient.activity_diagram = JSON.parse(patient.activity_diagram)
  }
  console.log(patient)

  return patient
}
