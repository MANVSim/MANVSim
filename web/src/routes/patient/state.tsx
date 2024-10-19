import {
  ChangeEvent,
  PropsWithChildren,
  ReactElement,
  createContext,
  useContext,
  useState,
} from "react"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getActions, getPatient } from "../../api"
import {
  Action,
  ActivityDiagram,
  MediaTypeEnum,
  Patient,
  State,
  mediaTypes,
} from "../../types"
import {
  Accordion,
  Button,
  Col,
  Container,
  ListGroup,
  Row,
} from "react-bootstrap"
import { Updater, useImmer } from "use-immer"
import { Form } from "react-router-dom"
import { WritableDraft } from "immer"
import { StateSelector } from "../../components/StateSelector"
import { default as FormBS } from "react-bootstrap/Form"
import NotAvailable from "../../components/NotAvailable"
import { v4 as uuidv4 } from "uuid"

type AttributeProps = PropsWithChildren<{ name: string }>

function Attribute({ name, children }: AttributeProps): ReactElement {
  return (
    <Row>
      <Col>{name}:</Col>
      <Col>{children}</Col>
    </Row>
  )
}

type SectionProps = PropsWithChildren<{
  title: string
}>

function Section({ title, children }: SectionProps): ReactElement {
  return (
    <Accordion.Item eventKey={title}>
      <Accordion.Header>{title}</Accordion.Header>
      <Accordion.Body className="d-grid gap-1">{children}</Accordion.Body>
    </Accordion.Item>
  )
}

interface TimelimitSectionProps {
  uuid: string
}

function TimelimitSection({ uuid }: TimelimitSectionProps): ReactElement {
  const { activityDiagram, updateActivityDiagram } = useLoaderDataContext()
  const state = activityDiagram.states[uuid]
  return (
    <Section title="Zeitlimit">
      <Attribute name="Folgezustand">
        <FormBS.Select
          value={state.after_time_state_uuid}
          onChange={(event): void => {
            const new_value = event.target.value
            updateActivityDiagram(
              (draft: WritableDraft<ActivityDiagram>): void => {
                draft.states[uuid].after_time_state_uuid =
                  uuid !== new_value ? new_value : ""
              },
            )
          }}
        >
          <option value={state.uuid}>Kein Folgezustand</option>
          {Object.values(activityDiagram.states).map((s: State) => {
            // List all states except the current one
            return s === state ? null : (
              <option key={s.uuid} value={s.uuid}>
                {s.uuid}
              </option>
            )
          })}
        </FormBS.Select>
      </Attribute>
      <Attribute name="Zeitlimit">
        <input
          disabled={state.after_time_state_uuid === ""}
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
      </Attribute>
    </Section>
  )
}

interface TreatmentSectionProps {
  uuid: string
}

function TreatmentSection({ uuid }: TreatmentSectionProps): ReactElement {
  const { actions, activityDiagram, updateActivityDiagram } =
    useLoaderDataContext()
  const state = activityDiagram.states[uuid]
  const [newTreatment, setNewTreatment] = useState({ id: -1, afterState: "" })
  return (
    <Section title="Behandlungen">
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
                        draft.states[uuid].treatments[event.target.value] =
                          afterState
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
                        draft.states[uuid].treatments[actionId] = new_value
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
              {Object.values(activityDiagram.states).map((state: State) => {
                return (
                  <option key={state.uuid} value={state.uuid}>
                    {state.uuid}
                  </option>
                )
              })}
            </FormBS.Select>
          </Col>
          <Col>
            <Button
              onClick={() => {
                updateActivityDiagram(
                  (draft: WritableDraft<ActivityDiagram>) => {
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
    </Section>
  )
}

interface ParameterSectionProps {
  uuid: string
}

function ParameterSection({ uuid }: ParameterSectionProps): ReactElement {
  const { activityDiagram, updateActivityDiagram } = useLoaderDataContext()
  const state = activityDiagram.states[uuid]
  const [newParameter, setNewParameter] = useState<string>("")
  return (
    <Section title="Parameter">
      <Container className="d-grid gap-3">
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
                                  (draft: WritableDraft<ActivityDiagram>) => {
                                    draft.states[uuid].conditions[name][
                                      i
                                    ].media_type = event.target
                                      .value as MediaTypeEnum
                                  },
                                )
                              }}
                            >
                              {Object.values(mediaTypes.enum).map(
                                (mediaType) => {
                                  return (
                                    <option key={mediaType} value={mediaType}>
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
                                  (draft: WritableDraft<ActivityDiagram>) => {
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
                                  (draft: WritableDraft<ActivityDiagram>) => {
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
                            {condition.media_reference || <NotAvailable />}
                          </Col>
                        </Row>
                      </div>
                    )
                  })}
                </Col>
              </Row>
            )
          })}

        <Row>
          <Col className="d-grid">
            <input
              value={newParameter}
              onChange={(event) => setNewParameter(event.target.value)}
              placeholder="Parametername"
            />
          </Col>
          <Col>
            <Button
              disabled={newParameter === "" || !!state.conditions[newParameter]}
              onClick={() => {
                updateActivityDiagram(
                  (draft: WritableDraft<ActivityDiagram>) => {
                    const conditions = draft.states[uuid].conditions
                    if (!conditions[newParameter]) {
                      conditions[newParameter] = []
                    }
                    conditions[newParameter].push({
                      media_type: mediaTypes.enum.TEXT,
                      title: "",
                      text: "",
                      media_reference: "",
                    })
                  },
                )
              }}
            >
              + Neuer Parameter
            </Button>
          </Col>
        </Row>
      </Container>
    </Section>
  )
}

interface StateEntryProps {
  uuid: string
}

function StateEntry({ uuid }: StateEntryProps): ReactElement {
  return (
    <ListGroup.Item>
      <h3>{uuid}</h3> {/* TODO: Replace with name */}
      <Accordion flush alwaysOpen defaultActiveKey="Parameter">
        <TimelimitSection uuid={uuid} />
        <TreatmentSection uuid={uuid} />
        <ParameterSection uuid={uuid} />
      </Accordion>
    </ListGroup.Item>
  )
}

interface ILoaderDataContext {
  activityDiagram: ActivityDiagram
  updateActivityDiagram: Updater<ActivityDiagram>
  actions: Map<string, Action>
}

const LoaderDataContext = createContext<ILoaderDataContext | null>(null)

function useLoaderDataContext() {
  const context = useContext(LoaderDataContext)
  if (context === null) {
    throw new Error("No LoaderDataContext provided")
  }
  return context
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
    <LoaderDataContext.Provider
      value={{
        activityDiagram: activityDiagram,
        updateActivityDiagram: updateActivityDiagram,
        actions: actions,
      }}
    >
      <h1>Zustände</h1>
      <div>Patient: {patient.name}</div>
      <hr />
      <Form method="PUT" className="d-grid gap-2">
        <ListGroup>
          {Object.values(activityDiagram.states).map((state: State) => (
            <StateEntry key={state.uuid} uuid={state.uuid} />
          ))}
          <ListGroup.Item className="d-grid">
            <Button
              onClick={() => {
                updateActivityDiagram((draft) => {
                  const uuid = uuidv4()
                  draft.states[uuid] = {
                    start_time: 0,
                    pause_time: 0,
                    uuid: uuid,
                    after_time_state_uuid: "",
                    timelimit: -1,
                    treatments: {},
                    conditions: {},
                  }
                })
              }}
            >
              Neuer Zustand
            </Button>
          </ListGroup.Item>
        </ListGroup>
        <Button type="submit">Speichern</Button>
      </Form>
    </LoaderDataContext.Provider>
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
