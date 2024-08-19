import { ReactElement } from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getPatient } from "../../api"
import { Patient, State } from "../../types"
import { ListGroup } from "react-bootstrap"

interface StateEntryProps {
  state: State
}

function StateEntry({ state }: StateEntryProps): ReactElement {
  return (
    <ListGroup.Item key={state.uuid}>
      <div>{state.uuid}</div>
      <div>Pausierte Zeit: {state.pause_time}</div>
      <div>Startzeit: {state.start_time}</div>
      <div>Zeitlimit: {state.timelimit}</div>
      <div>
        Folgezustand nach Zeitlimit: {state.after_time_state_uuid || "-"}
      </div>
      <div>Behandlungen:</div>
      <div>Zustände:</div>
    </ListGroup.Item>
  )
}

export default function StateRoute(): ReactElement {
  const patient = useLoaderData() as Patient
  return (
    <div>
      <h1>Zustände</h1>
      <div>Patient: {patient.name}</div>
      <hr />
      <ListGroup>
        {Object.values(patient.activity_diagram.states).map((state: State) => (
          <StateEntry state={state} key={state.uuid} />
        ))}
      </ListGroup>
    </div>
  )
}

StateRoute.loader = async function ({
  params,
}: LoaderFunctionArgs): Promise<Patient> {
  const id = params.patientId
  if (id === undefined) {
    throw new Error("No patient ID provided")
  }
  const patient = await getPatient(id)

  return {
    ...patient,
    activity_diagram: JSON.parse(patient.activity_diagram || "{}"),
  }
}
