import { ActionFunctionArgs, useLoaderData, redirect } from "react-router"
import { getTemplates, startScenario } from "../api"
import Button from "react-bootstrap/Button"
import {
  Accordion,
  AccordionBody,
  AccordionHeader,
  AccordionItem,
} from "react-bootstrap"
import { Template } from "../types"
import { ReactElement } from "react"
import CsrfForm from "../components/CsrfForm"
import { LinkContainer } from "react-router-bootstrap"

function ExecutionEntry({
  execution,
}: Readonly<{ execution: number }>): ReactElement {
  return (
    <LinkContainer to={`/execution/${execution}`} className="d-grid">
      <Button>{execution}</Button>
    </LinkContainer>
  )
}

function TemplateEntry({
  template,
  index,
}: Readonly<{ template: Template; index: number }>): ReactElement {
  const { name, executions, id } = template

  return (
    <AccordionItem eventKey={index.toString()}>
      <AccordionHeader>{name}</AccordionHeader>
      <AccordionBody className="d-grid gap-2">
        <CsrfForm method="post" className="d-grid">
          <input type="hidden" name="id" value={id} />
          <Button type="submit">Neue Ausführung</Button>
        </CsrfForm>
        <hr />
        {executions.length ? (
          executions.map((execution: number) => (
            <ExecutionEntry key={execution} execution={execution} />
          ))
        ) : (
          <div className="fw-light fst-italic">Keine Ausführungen</div>
        )}
      </AccordionBody>
    </AccordionItem>
  )
}

export default function Scenario(): ReactElement {
  const loaderData = useLoaderData() as { templates: Array<Template> }
  const { templates } = loaderData
  return (
    <div>
      <h2>Vorlagen</h2>
      <p>Die folgenden Vorlagen sind verfügbar:</p>
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
  )
}

Scenario.loader = async function (): Promise<{ templates: Template[] }> {
  const templates = await getTemplates()
  return { templates: templates }
}

Scenario.action = async function ({
  request,
}: ActionFunctionArgs<Request>): Promise<Response> {
  const formData = await request.formData()
  const result = await startScenario(formData)
  return redirect(`/execution/${result.id}`)
}
