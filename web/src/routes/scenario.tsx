import { ActionFunctionArgs, useLoaderData, useNavigate } from "react-router"
import { createExecution, getActiveExecutions, getTemplates } from "../api"
import {
  Accordion,
  AccordionBody,
  AccordionHeader,
  AccordionItem,
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
    <AccordionItem eventKey={index.toString()} aria-expanded={isAccordionOpen}>
      <AccordionHeader onClick={handleOpenAccordion}>
        <div className="d-flex justify-content-between w-100">
          <div className="d-flex align-items-center">
            <div>
              {name}
            </div>
          </div>
          <div className="me-3">
            <button className="btn btn-outline-primary btn-sm" onClick={handleButtonClick}>+</button>
          </div>
        </div>
      </AccordionHeader>
      <AccordionBody>
        {executions.length ? (
          executions.map((execution: number) => (
            <div>
              <div className="w-100 d-flex">
                <div id="lobby-hover" className="bg-light rounded flex-fill me-2 d-flex justify-content-center" onClick={() => navigate(`/execution/${execution}`)}>
                  <div className="align-self-center">{execution}</div>
                </div>
                <button className="btn btn-primary me-2" onClick={handleButtonClick}>Bearbeiten</button>
                <button className="btn btn-primary me-2" onClick={handleButtonClick}>Aktivieren</button>
              </div>
              <CsrfForm className={`d-flex mt-2 ${isVisible ? '' : 'd-none'}`}>
                <input className="form-control flex-fill me-3" type="text" placeholder="Name der Execution" name="name" />
                <button className="btn btn-primary" type="submit">Save</button>
              </CsrfForm>
            </div>
          ))
        ) : (
          <div className="fw-light fst-italic">Keine Ausführungen</div>
        )}
      </AccordionBody>
    </AccordionItem>
  )
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

function activateExecution() {
  const navigate = useNavigate();
  // TODO
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
            {activeExecutions.map((item, index) => (
              <li className="d-flex border p-1" key={index}>
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
            <button className="btn btn-outline-primary ps-5 pe-5 align-self-end mb-3" onClick={() => alert(`/create`)}>Neu</button>
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
}: ActionFunctionArgs<Request>): Promise<Response> {
  const formData = await request.formData()
  const result = await createExecution(formData)
  return result
}
