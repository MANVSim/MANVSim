import { ActionFunctionArgs, NavigateFunction, redirect, useLoaderData, useNavigate } from "react-router"
import { getActiveExecutions, getTemplates, postActivateExecution, tryFetchJson } from "../api"
import {
  Accordion,
  AccordionBody,
  AccordionHeader,
  AccordionItem,
  Form as FormBS
} from "react-bootstrap"
import { ExecutionData, Template } from "../types"
import { ReactElement, useState } from "react"
import CsrfForm from "../components/CsrfForm"
import './scenario.css'

function TemplateEntry({
  template,
  index,
}: Readonly<{ template: Template; index: number }>): ReactElement {
  const navigate = useNavigate();
  const { name, executions } = template
  const [isVisible, setIsVisible] = useState(false);
  const [isAccordionOpen, setIsAccordionOpen] = useState(false);
  const [formDataTemp, setFormData] = useState({
    scenario_id: -1, // Initial value for scenario_id
    name: '' // Initial value for name
  });

  const handleButtonClick = (event: { stopPropagation: () => void }) => {
    if (isAccordionOpen) {
      event.stopPropagation(); // Prevents the click event from bubbling up
    }
    setIsAccordionOpen(true)
    setIsVisible(!isVisible);
  }
  const handleOpenAccordion = () => {
    setIsAccordionOpen(!isAccordionOpen)
  }

  return (
    <AccordionItem eventKey={index.toString()}>
      <AccordionHeader onClick={handleOpenAccordion} aria-expanded={isAccordionOpen}>
        <div className="d-flex justify-content-between w-100">
          <div className="d-flex align-items-center">
            <div>
              {name}
            </div>
          </div>
          <div className="me-3">
            <div id="add-btn" className="btn btn-outline-primary btn-sm" onClick={handleButtonClick}>+</div>
          </div>
        </div>
      </AccordionHeader>
      <AccordionBody>
        {executions.length ? (
          executions.map((execution: number) => (
            <li key={execution} className="w-100 d-flex mb-2">
              <button id="lobby-hover" className="btn btn-light flex-fill me-2 d-flex justify-content-center" onClick={() => navigate(`/execution/${execution}`)}>
                <div className="align-self-center">{execution}</div>
              </button>
              <div className="w-25">
                <button className="btn btn-success me-2 w-100" onClick={() => activateExecution(execution, navigate)}>Aktivieren</button>
              </div>
            </li>
          ))
        ) : (
          <div className="fw-light fst-italic">Keine Ausführungen</div>
        )}
        <CsrfForm className={`d-flex mt-2 ${isVisible ? '' : 'd-none'}`} method="post" action="/execution">
          <FormBS.Group className="d-none" controlId="formGroupScenarioId">
            <FormBS.Label>Scenario-ID</FormBS.Label>
            <FormBS.Control
              required
              type="integer"
              name="scenario_id"
              value={template.id}
              onChange={(e) => setFormData({ ...formDataTemp, scenario_id: parseInt(e.target.value) })}
              readOnly
            />
          </FormBS.Group>
          <FormBS.Group className="flex-fill me-3" controlId="formGroupName">
            <FormBS.Control
              required
              type="text"
              placeholder="Name der Execution"
              name="name"
              onChange={(e) => setFormData({ ...formDataTemp, name: e.target.value })}
            />
          </FormBS.Group>
          <button className="btn btn-primary w-25" type="submit">Erstellen</button>
        </CsrfForm>
      </AccordionBody>
    </AccordionItem>
  )
}


export default function Scenario(): ReactElement {
  const loaderData = useLoaderData() as { templates: Array<Template>, activeExecutions: Array<ExecutionData> };
  const { templates, activeExecutions } = loaderData;
  const navigate = useNavigate();
  return (
    <div className="mt-3">
      <div>
        <h2>Aktive Scenarios</h2>
        <p>Die folgenden Scenarios sind gestartet:</p>
        {activeExecutions.length ? (
          <div className="mb-5">
            {activeExecutions.map((item) => (
              <li className="d-flex border p-1" key={item.id}>
                <div className="mt-1 ms-2 me-auto">
                  <span>{item.name}</span>
                </div>
                <div id="active-execution-status" className="mt-1 me-5" >
                  <span style={{ color: getColor(item.status) }}>{item.status}</span>
                </div>
                <div className="me-2 ms-5">
                  <button className="btn btn-secondary me-2" onClick={() => navigate(`/execution/${item.id}`)}>Verwalten</button>
                </div>
              </li>
            ))}
          </div>
        ) : (
          <p>
            <i>Es sind derzeit keine Scenarios aktiv.</i>
          </p>
        )}
      </div>
      <div className="pt-3 border-top">
        <div className="d-flex justify-content-between">
          <div>
            <h2>Vorlagen</h2>
            <p>Die folgenden Vorlagen sind verfügbar:</p>
          </div>
          <div className="d-flex">
            <button className="btn btn-outline-primary ps-5 pe-5 align-self-end mb-3" onClick={() => alert("Not yet implemented")}>Neu</button>
          </div>
        </div>
        {templates.length ? (
          <Accordion>
            {templates.map((t: Template, index: number) => (
              <TemplateEntry key={t.id} template={t} index={index} />
            ))}
          </Accordion>
        ) : (
          <p>
            <i>Keine Vorlagen</i>
          </p>
        )}
      </div>
    </div>
  )
}

Scenario.loader = async function (): Promise<{ templates: Template[], activeExecutions: ExecutionData[] }> {
  const templates = await getTemplates()
  const executions = await getActiveExecutions()
  return { templates: templates, activeExecutions: executions }
}

Scenario.action = async function ({
  request,
}: ActionFunctionArgs<Request>) {
  const formData = await request.formData()
  const id_json = await tryFetchJson<ExecutionData>("execution", { body: formData, method: "POST" })
  if (id_json.id) return redirect(`/execution/${id_json.id}`)
  else {
    alert(`No execution created due to input/db error.`)
    return redirect("/scenario")
  }
}


function getColor(status: string) {
  switch (status) {
    case 'PENDING':
      return 'orange';
    case 'RUNNING':
      return 'green';
    case 'FINISHED':
      return 'red';
    default:
      return 'black';
  }
}

async function activateExecution(exec_id: number, navigate: NavigateFunction) {
  const response = postActivateExecution(exec_id)

  if ([200, 201].includes((await response).status)) {
    navigate(`/execution/${exec_id}`)
  } else {
    console.error("Unable to start execution. Response status:", (await response).status);
    throw new Error("Unable to start execution.")
  }
}