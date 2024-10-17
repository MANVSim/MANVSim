import { ChangeEvent, ReactElement } from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getActions, getPatient } from "../../api"
import { Action, ActivityDiagram, Patient, State } from "../../types"
import { Button, Col, Container, ListGroup, Row } from "react-bootstrap"
import { Updater, useImmer } from "use-immer"
import { Form } from "react-router-dom"
import { WritableDraft } from "immer"
import { StateSelector } from "../../components/StateSelector"

interface StateEntryProps {
  uuid: string
  activityDiagram: ActivityDiagram
  updateActivityDiagram: Updater<ActivityDiagram>
  actions: Map<string, Action>
}

function StateEntry({
  uuid,
  activityDiagram,
  updateActivityDiagram,
  actions,
}: StateEntryProps): ReactElement {
  const state = activityDiagram.states[uuid]
  function actionIdToName(id: string): string {
    return actions.get(id)?.name || `Unbekannt (${id})`
  }

  return (
    <ListGroup.Item>
      <div>{uuid}</div>
      <Container>
        <Row>
          <Col>Folgezustand nach Zeitlimit:</Col>
          <Col>
            <StateSelector
              current={state.after_time_state_uuid}
              update={(new_value: string): void => {
                updateActivityDiagram(
                  (draft: WritableDraft<ActivityDiagram>): void => {
                    draft.states[uuid].after_time_state_uuid =
                      uuid !== new_value ? new_value : ""
                  },
                )
              }}
              states={activityDiagram.states}
            />
          </Col>
        </Row>
        {state.after_time_state_uuid && (
          <Row>
            <Col>Zeitlimit:</Col>
            <Col>
              <input
                type="number"
                value={state.timelimit}
                onChange={(event: ChangeEvent<HTMLInputElement>) => {
                  updateActivityDiagram(
                    (draft: WritableDraft<ActivityDiagram>): void => {
                      draft.states[uuid].timelimit = parseInt(
                        event.target.value,
                      )
                    },
                  )
                }}
              />
            </Col>
          </Row>
        )}
        <Row>
          <Col>Behandlungen:</Col>
        </Row>
        <Row>
          <Col>
            <Container>
              {Object.entries(state.treatments).map(
                ([actionId, afterState]: [string, string]): ReactElement => (
                  <Row key={actionId}>
                    <Col>{actionIdToName(actionId)}</Col>
                    <Col>
                      <StateSelector
                        current={afterState}
                        states={activityDiagram.states}
                        update={(new_value: string): void => {
                          updateActivityDiagram(
                            (draft: WritableDraft<ActivityDiagram>): void => {
                              draft.states[uuid].treatments[actionId] =
                                new_value
                            },
                          )
                        }}
                      />
                    </Col>
                    <Col>
                      <Button
                        variant="danger"
                        onClick={() => {
                          updateActivityDiagram(
                            (draft: WritableDraft<ActivityDiagram>) => {
                              delete draft.states[uuid].treatments[actionId]
                            },
                          )
                        }}
                      >
                        Löschen
                      </Button>
                    </Col>
                  </Row>
                ),
              )}
            </Container>
          </Col>
        </Row>
      </Container>

      <div>Parameter:</div>
    </ListGroup.Item>
  )
}

interface LoaderData {
  patient: Patient
  actions: Map<string, Action>
}

export default function StateRoute(): ReactElement {
  const { patient, actions } = useLoaderData() as LoaderData

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
              actions={actions}
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
}: LoaderFunctionArgs): Promise<LoaderData> {
  const id = params.patientId
  if (id === undefined) {
    throw new Error("No patient ID provided")
  }
  const patient = await getPatient(id)

  const apiActions = await getActions()

  const actions = new Map()
  for (const a of apiActions) {
    actions.set(a.id.toString(), a)
  }

  return {
    patient: {
      ...patient,
      activity_diagram: JSON.parse(patient.activity_diagram || "{}"),
    },
    actions: actions,
  }
}

StateRoute.action = async function () {
  return null
}
