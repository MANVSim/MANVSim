import { ChangeEvent, ReactElement, useEffect, useState } from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getActions, getPatient } from "../../api"
import { Action, ActivityDiagram, Patient, State } from "../../types"
import { Button, Col, Container, ListGroup, Row } from "react-bootstrap"
import { Updater, useImmer } from "use-immer"
import { Form } from "react-router-dom"
import { WritableDraft } from "immer"
import { StateSelector } from "../../components/StateSelector"
import { default as FormBS } from "react-bootstrap/Form"
import NotAvailable from "../../components/NotAvailable"

interface StateEntryProps {
  uuid: string
  activityDiagram: ActivityDiagram
  updateActivityDiagram: Updater<ActivityDiagram>
  actions: Map<string, Action>
}

enum MediaType {
  TEXT = "TEXT",
  IMAGE = "IMAGE",
  VIDEO = "VIDEO",
}

function StateEntry({
  uuid,
  activityDiagram,
  updateActivityDiagram,
  actions,
}: StateEntryProps): ReactElement {
  const state = activityDiagram.states[uuid]
  useEffect(() => {
    console.log(state.conditions)
  }, [state])
  const [newTreatment, setNewTreatment] = useState({ id: -1, afterState: "" })

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
            <Container className="d-grid gap-2">
              {Object.entries(state.treatments).map(
                ([actionId, afterState]: [string, string]): ReactElement => (
                  <Row key={actionId}>
                    <Col>
                      <FormBS.Select
                        value={actionId}
                        onChange={(event) => {
                          updateActivityDiagram(
                            (draft: WritableDraft<ActivityDiagram>): void => {
                              delete draft.states[uuid].treatments[actionId]
                              draft.states[uuid].treatments[
                                event.target.value
                              ] = afterState
                            },
                          )
                        }}
                      >
                        {Array.from(actions).map(([id, value]) => {
                          return (
                            <option value={id} key={id}>
                              {value.name}
                            </option>
                          )
                        })}
                      </FormBS.Select>
                    </Col>
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
              <Row>
                <Col>
                  {
                    <FormBS.Select
                      value={newTreatment.id}
                      onChange={(event) => {
                        setNewTreatment({
                          ...newTreatment,
                          id: parseInt(event.target.value),
                        })
                      }}
                    >
                      <option value={-1} disabled>
                        Behandlung auswählen
                      </option>
                      {Array.from(actions).map(([id, value]) => {
                        return (
                          <option key={id} value={id}>
                            {value.name}
                          </option>
                        )
                      })}
                    </FormBS.Select>
                  }
                </Col>
                <Col>
                  <FormBS.Select
                    value={newTreatment.afterState}
                    onChange={(event) => {
                      setNewTreatment({
                        ...newTreatment,
                        afterState: event.target.value,
                      })
                    }}
                  >
                    <option value={""} disabled>
                      Folgezustand wählen
                    </option>
                    {Object.values(activityDiagram.states).map(
                      (state: State) => {
                        return (
                          <option key={state.uuid} value={state.uuid}>
                            {state.uuid}
                          </option>
                        )
                      },
                    )}
                  </FormBS.Select>
                </Col>
                <Col>
                  <Button
                    onClick={() => {
                      updateActivityDiagram(
                        (draft: WritableDraft<ActivityDiagram>) => {
                          console.log(newTreatment)
                          // Do not do anything when the user tries to add a treatment with no action or no after state
                          if (
                            newTreatment.id === -1 ||
                            newTreatment.afterState === ""
                          ) {
                            return
                          }

                          draft.states[uuid].treatments[newTreatment.id] =
                            newTreatment.afterState
                          setNewTreatment({ id: -1, afterState: "" })
                        },
                      )
                    }}
                  >
                    +
                  </Button>
                </Col>
              </Row>
            </Container>
          </Col>
        </Row>
        <Row>
          <Col>Parameter</Col>
        </Row>
        <Row>
          <Col>
            <Container>
              {Object.entries(state.conditions)
                .sort()
                .map(([name, conditions]) => {
                  return (
                    <Row key={name}>
                      <Col>{name}</Col>
                      <Col>
                        {conditions.map((condition, i) => {
                          return (
                            <div key={i} className="d-grid gap-1">
                              <Row>
                                <Col>Medientyp:</Col>
                                <Col>
                                  <FormBS.Select
                                    value={condition.media_type}
                                    onChange={(event) => {
                                      updateActivityDiagram(
                                        (
                                          draft: WritableDraft<ActivityDiagram>,
                                        ) => {
                                          draft.states[uuid].conditions[name][
                                            i
                                          ].media_type = event.target.value
                                        },
                                      )
                                    }}
                                  >
                                    {Object.values(MediaType).map(
                                      (mediaType) => {
                                        return (
                                          <option
                                            key={mediaType}
                                            value={mediaType}
                                          >
                                            {mediaType}
                                          </option>
                                        )
                                      },
                                    )}
                                  </FormBS.Select>
                                </Col>
                              </Row>
                              <Row>
                                <Col>Titel:</Col>
                                <Col>
                                  <input
                                    value={condition.title || ""}
                                    onChange={(event) => {
                                      updateActivityDiagram(
                                        (
                                          draft: WritableDraft<ActivityDiagram>,
                                        ) => {
                                          draft.states[uuid].conditions[name][
                                            i
                                          ].title = event.target.value
                                        },
                                      )
                                    }}
                                  />
                                </Col>
                              </Row>
                              <Row>
                                <Col>Text:</Col>
                                <Col>
                                  <input
                                    value={condition.text || ""}
                                    onChange={(event) => {
                                      updateActivityDiagram(
                                        (
                                          draft: WritableDraft<ActivityDiagram>,
                                        ) => {
                                          draft.states[uuid].conditions[name][
                                            i
                                          ].text = event.target.value
                                        },
                                      )
                                    }}
                                  />
                                </Col>
                              </Row>
                              <Row>
                                <Col>Medienreferenz:</Col>
                                <Col>
                                  {condition.media_reference || (
                                    <NotAvailable />
                                  )}
                                </Col>
                              </Row>
                            </div>
                          )
                        })}
                      </Col>
                    </Row>
                  )
                })}
            </Container>
          </Col>
        </Row>
      </Container>
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
