import { ReactElement } from "react"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
} from "react-router"
import { getPatient } from "../../api"
import { ActivityDiagram, Patient, State } from "../../types"
import { Button, ListGroup } from "react-bootstrap"
import { Updater, useImmer } from "use-immer"
import { Form } from "react-router-dom"

interface StateEntryProps {
  state: State
  updateActivityDiagram: Updater<ActivityDiagram>
}

function StateEntry({
  state,
  updateActivityDiagram,
}: StateEntryProps): ReactElement {
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
      <div>Parameter:</div>
    </ListGroup.Item>
  )
}

export default function StateRoute(): ReactElement {
  const patient = useLoaderData() as Patient
  const [activityDiagram, updateActivityDiagram] = useImmer(
    patient.activity_diagram,
  )
  return (
    <div>
      <h1>Zustände</h1>
      <div>Patient: {patient.name}</div>
      <hr />
      <Form method="PUT" className="d-grid gap-2">
        <ListGroup>
          {Object.values(activityDiagram.states).map((state: State) => (
            <StateEntry
              key={state.uuid}
              state={state}
              updateActivityDiagram={updateActivityDiagram}
            />
          ))}
        </ListGroup>
        <Button type="submit">Speichern</Button>
      </Form>
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

StateRoute.action = async function ({ params }: ActionFunctionArgs) {
  return null
}
