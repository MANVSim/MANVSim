import {
  ChangeEvent,
  PropsWithChildren,
  ReactElement,
  createContext,
  useContext,
  useState,
} from "react"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
  useNavigation,
} from "react-router"
import { getActions, getPatient, putPatient } from "../../api"
import {
  Action,
  ActivityDiagram,
  Condition,
  Patient,
  State,
  mediaTypes,
} from "../../types"
import {
  Accordion,
  Button,
  ButtonProps,
  Col,
  Collapse,
  Container,
  FormSelectProps,
  ListGroup,
  Row,
  Spinner,
  Stack,
  Table,
} from "react-bootstrap"
import { DraftFunction, useImmer } from "use-immer"
import { useSubmit } from "react-router-dom"
import { WritableDraft } from "immer"
import { StateSelector } from "../../components/StateSelector"
import Form from "react-bootstrap/Form"
import { v4 as uuidv4 } from "uuid"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import {
  faPlus,
  faTrash,
  faSave,
  faEdit,
  faCheck,
  faCaretDown,
  faCaretUp,
  faClone,
  IconDefinition,
} from "@fortawesome/free-solid-svg-icons"
import { toast } from "react-toastify"
import MediaEditor from "../../components/MediaEditor"

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
        <Form.Select
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
                {s.name}
              </option>
            )
          })}
        </Form.Select>
      </Attribute>
      <Attribute name="Zeitlimit">
        <input
          disabled={state.after_time_state_uuid === ""}
          type="number"
          value={state.timelimit < 0 ? "" : state.timelimit}
          onChange={(event: ChangeEvent<HTMLInputElement>) => {
            const value =
              event.target.value === "" ? -1 : parseInt(event.target.value)
            updateActivityDiagram(
              (draft: WritableDraft<ActivityDiagram>): void => {
                draft.states[uuid].timelimit = value
              },
            )
          }}
        />
        <span>&nbsp;s</span>
      </Attribute>
    </Section>
  )
}

interface ActionSelectorProps extends FormSelectProps {
  state: State
}

function ActionSelector({
  state,
  ...props
}: ActionSelectorProps): ReactElement {
  const { actions } = useLoaderDataContext()
  return (
    <Form.Select {...props}>
      <option value={-1} disabled>
        Behandlung auswählen
      </option>
      {Array.from(actions).map(([id, value]) => {
        if (id in state.treatments && id !== props.value) {
          return null
        }
        return (
          <option key={id} value={id}>
            {value.name}
          </option>
        )
      })}
    </Form.Select>
  )
}

interface TreatmentSectionProps {
  uuid: string
}

function TreatmentSection({ uuid }: TreatmentSectionProps): ReactElement {
  const { activityDiagram, updateActivityDiagram } = useLoaderDataContext()
  const state = activityDiagram.states[uuid]
  const [newTreatment, setNewTreatment] = useState({ id: -1, afterState: "" })
  const canCreateNewTreatment =
    newTreatment.id !== -1 && newTreatment.afterState !== ""
  return (
    <Section title="Behandlungen">
      <Container className="d-grid gap-2">
        {Object.entries(state.treatments).map(
          ([actionId, afterState]: [string, string]): ReactElement => (
            <Row key={actionId}>
              <Col>
                <ActionSelector
                  state={state}
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
                />
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
                  <FontAwesomeIcon icon={faTrash} />
                </Button>
              </Col>
            </Row>
          ),
        )}
        <Row>
          <Col>
            <ActionSelector
              state={state}
              value={newTreatment.id}
              onChange={(event) => {
                setNewTreatment({
                  ...newTreatment,
                  id: parseInt(event.target.value),
                })
              }}
            />
          </Col>
          <Col>
            <Form.Select
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
                    {state.name}
                  </option>
                )
              })}
            </Form.Select>
          </Col>
          <Col>
            <Button
              onClick={() => {
                updateActivityDiagram(
                  (draft: WritableDraft<ActivityDiagram>) => {
                    // Do not do anything when the user tries to add a treatment with no action or no after state
                    if (!canCreateNewTreatment) {
                      return
                    }

                    draft.states[uuid].treatments[newTreatment.id] =
                      newTreatment.afterState
                    setNewTreatment({ id: -1, afterState: "" })
                  },
                )
              }}
              disabled={!canCreateNewTreatment}
            >
              <FontAwesomeIcon icon={faPlus} />
            </Button>
          </Col>
        </Row>
      </Container>
    </Section>
  )
}

interface ParameterSectionConditionProps {
  name: string
  conditions: Condition[]
  uuid: string
}

function ParameterSectionCondition({
  name,
  conditions,
  uuid,
}: ParameterSectionConditionProps): ReactElement {
  const { updateActivityDiagram } = useLoaderDataContext()
  const [open, setOpen] = useState(false)
  return (
    <tr>
      <td style={{ width: "1%" }} className="align-top">
        {name}
      </td>
      <td>
        <div className="d-grid">
          <Button
            variant="outline-primary"
            size="lg"
            onClick={() => {
              setOpen(!open)
            }}
          >
            {open ? (
              <FontAwesomeIcon icon={faCaretUp} />
            ) : (
              <FontAwesomeIcon icon={faCaretDown} />
            )}
          </Button>
        </div>
        <Collapse in={open} mountOnEnter>
          <div>
            <MediaEditor
              mediaArray={conditions}
              updateMediaArray={(updateFnc) => {
                updateActivityDiagram((draft) => {
                  updateFnc(draft.states[uuid].conditions[name])
                })
              }}
            />
          </div>
        </Collapse>
      </td>
      <td style={{ width: "1%" }} className="align-top">
        <Button
          variant="danger"
          onClick={() => {
            updateActivityDiagram((draft: WritableDraft<ActivityDiagram>) => {
              delete draft.states[uuid].conditions[name]
            })
          }}
          title="Parameter löschen"
        >
          <FontAwesomeIcon icon={faTrash} />
        </Button>
      </td>
    </tr>
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
      {/* <Container className="d-grid gap-3"> */}
      <Table bordered>
        <tbody>
          <tr>
            <th>Name</th>
            <th>Medien</th>
            <th>{/* Empty column for the delete button */}</th>
          </tr>
          {Object.entries(state.conditions)
            .sort()
            .map(([name, conditions]) => {
              return (
                <ParameterSectionCondition
                  key={name}
                  name={name}
                  conditions={conditions}
                  uuid={uuid}
                />
              )
            })}

          <tr>
            <td colSpan={3}>
              <Stack direction="horizontal" gap={1}>
                <input
                  value={newParameter}
                  onChange={(event) => setNewParameter(event.target.value)}
                  placeholder="Parametername"
                />
                <Button
                  disabled={
                    newParameter === "" || newParameter in state.conditions
                  }
                  onClick={() => {
                    setNewParameter("")
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
                  <FontAwesomeIcon icon={faPlus} /> Neuer Parameter
                </Button>
              </Stack>
            </td>
          </tr>
        </tbody>
      </Table>
    </Section>
  )
}

interface SmallIconButtonProps extends ButtonProps {
  icon: IconDefinition
}

function SmallIconButton({
  icon,
  ...props
}: SmallIconButtonProps): ReactElement {
  return (
    <Button size="sm" {...props}>
      {<FontAwesomeIcon icon={icon} />}
    </Button>
  )
}

interface StateEntryProps {
  uuid: string
}

function StateEntry({ uuid }: StateEntryProps): ReactElement {
  const { activityDiagram, updateActivityDiagram } = useLoaderDataContext()
  const state = activityDiagram.states[uuid]
  const [editing, setEditing] = useState(false)
  const statesCount = Object.keys(activityDiagram.states).length
  return (
    <ListGroup.Item>
      <h3 className="hstack d-flex">
        {editing ? (
          <input
            value={state.name}
            onChange={(event) => {
              updateActivityDiagram((draft: WritableDraft<ActivityDiagram>) => {
                draft.states[uuid].name = event.target.value
              })
            }}
          />
        ) : (
          state.name
        )}
        <SmallIconButton
          title="Zustandsnamen ändern"
          variant="link"
          icon={editing ? faCheck : faEdit}
          onClick={() => setEditing(!editing)}
        />
        <div className="ms-auto gap-1 d-flex">
          <SmallIconButton
            title="Duplizieren"
            icon={faClone}
            onClick={() => {
              const new_uuid = uuidv4()
              updateActivityDiagram((draft: WritableDraft<ActivityDiagram>) => {
                draft.states[new_uuid] = {
                  ...state,
                  name: `${state.name} (Kopie)`,
                  uuid: new_uuid,
                }
              })
            }}
          />
          <SmallIconButton
            disabled={statesCount <= 1 || activityDiagram.current === uuid}
            icon={faTrash}
            variant="danger"
            title="Löschen"
            onClick={() => {
              updateActivityDiagram((draft: WritableDraft<ActivityDiagram>) => {
                delete draft.states[uuid]
              })
            }}
          />
        </div>
      </h3>
      <Form.Check
        name="start-state"
        type="radio"
        label="Startzustand"
        checked={activityDiagram.current === uuid}
        onChange={(event) => {
          if (!event.target.checked) {
            return
          }
          updateActivityDiagram((draft: WritableDraft<ActivityDiagram>) => {
            draft.current = uuid
          })
        }}
      />
      <Accordion flush alwaysOpen>
        <TimelimitSection uuid={uuid} />
        <TreatmentSection uuid={uuid} />
        <ParameterSection uuid={uuid} />
      </Accordion>
    </ListGroup.Item>
  )
}

interface ILoaderDataContext {
  activityDiagram: ActivityDiagram
  updateActivityDiagram: (fnc: DraftFunction<ActivityDiagram>) => void
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
  const { patient: loaderPatient, actions } = useLoaderData() as LoaderData

  const [patient, updatePatient] = useImmer<Patient>(loaderPatient)
  const activityDiagram = patient.activity_diagram

  function updateActivityDiagram(
    updateFnc: DraftFunction<ActivityDiagram>,
  ): void {
    updatePatient((draft: WritableDraft<Patient>): void => {
      updateFnc(draft.activity_diagram)
    })
  }

  const submit = useSubmit()

  const { state } = useNavigation()

  return (
    <LoaderDataContext.Provider
      value={{
        activityDiagram: activityDiagram,
        updateActivityDiagram: updateActivityDiagram,
        actions: actions,
      }}
    >
      <h1>Patient</h1>
      <div className="my-1">
        Name:{" "}
        <input
          value={patient.name}
          onChange={(event) => {
            updatePatient((draft) => {
              draft.name = event.target.value
            })
          }}
        />
      </div>
      <Button
        className="my-1"
        disabled={state !== "idle"}
        onClick={() => {
          submit(patient, {
            method: "PUT",
            encType: "application/json",
          })
        }}
      >
        {state === "idle" ? (
          <FontAwesomeIcon icon={faSave} />
        ) : (
          <Spinner role="status" size="sm" />
        )}
      </Button>
      <hr />
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
                  name: "",
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
            <FontAwesomeIcon icon={faPlus} /> Neuer Zustand
          </Button>
        </ListGroup.Item>
      </ListGroup>
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
    patient: patient,
    actions: actions,
  }
}

StateRoute.action = async function ({
  request,
  params: { patientId },
}: ActionFunctionArgs) {
  if (patientId === undefined) {
    throw new Error("No patient ID provided")
  }
  const patient: Patient = await request.json()

  const response = await putPatient(patientId, patient)
  if (!response.ok) {
    toast.error("Patient konnte nicht gespeichert werden")
  }
  toast.success("Patient gespeichert")

  return null
}
