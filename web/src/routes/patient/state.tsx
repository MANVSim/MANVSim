import { ChangeEvent, ReactElement } from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getPatient } from "../../api"
import { ActivityDiagram, Patient, State } from "../../types"
import { Button, ListGroup, Stack } from "react-bootstrap"
import { Updater, useImmer } from "use-immer"
import { Form } from "react-router-dom"
import { WritableDraft } from "immer"

interface StateEntryProps {
  uuid: string
  activityDiagram: ActivityDiagram
  updateActivityDiagram: Updater<ActivityDiagram>
}

function StateEntry({
  uuid,
  activityDiagram,
  updateActivityDiagram,
}: StateEntryProps): ReactElement {
  const state = activityDiagram.states[uuid]
  return (
    <ListGroup.Item>
      <div>{uuid}</div>
      <Stack direction="horizontal" className="gap-1">
        <div>Folgezustand nach Zeitlimit:</div>
        <select
          value={state.after_time_state_uuid}
          onChange={(event: ChangeEvent<HTMLSelectElement>): void => {
            updateActivityDiagram(
              (draft: WritableDraft<ActivityDiagram>): void => {
                console.log(event.target.value)

                draft.states[uuid].after_time_state_uuid = event.target.value
              },
            )
          }}
        >
          <option value="">-</option>
          {Object.values(activityDiagram.states).map((s: State) => (
            <option key={s.uuid}>{s.uuid}</option>
          ))}
        </select>
      </Stack>
      {state.after_time_state_uuid && (
        <Stack direction="horizontal" className="gap-1">
          <div>Zeitlimit:</div>
          <input
            type="number"
            value={state.timelimit}
            onChange={(event: ChangeEvent<HTMLInputElement>) => {
              updateActivityDiagram(
                (draft: WritableDraft<ActivityDiagram>): void => {
                  draft.states[uuid].timelimit = parseInt(event.target.value)
                },
              )
            }}
          />
        </Stack>
      )}
      <div>Behandlungen:</div>
      {Object.entries(state.treatments).map(([treatmentId, afterState]) => (
        <div key={treatmentId}>
          {treatmentId} : {afterState}
        </div>
      ))}
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
              uuid={state.uuid}
              activityDiagram={activityDiagram}
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

StateRoute.action = async function () {
  return null
}
