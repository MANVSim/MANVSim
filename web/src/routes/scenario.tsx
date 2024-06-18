import { ActionFunctionArgs, useLoaderData, redirect } from "react-router"
import { getTemplates, startScenario } from "../api"
import { Form } from "react-router-dom"
import Button from "react-bootstrap/Button"
import { ListGroup } from "react-bootstrap"
import { useCsrf } from "../contexts/use"
import { Template } from "../types"
import { ReactElement } from "react"

function TemplateEntry({
  template,
}: Readonly<{ template: Template }>): ReactElement {
  const { id, players, name } = template
  const csrfToken = useCsrf()

  return (
    <ListGroup.Item>
      <Form method="post">
        {/* <span>{name} ({players} Spieler) </span> */}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <input type="hidden" name="id" value={id} />
        <Button type="submit">
          {name} ({players} Spieler)
        </Button>
      </Form>
    </ListGroup.Item>
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
        <ListGroup>
          {templates.map((t: Template) => (
            <TemplateEntry key={t.id} template={t} />
          ))}
        </ListGroup>
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
