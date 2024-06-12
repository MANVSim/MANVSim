import { ActionFunctionArgs, useActionData, useLoaderData } from "react-router"
import { Template, getTemplates, startScenario } from "../api"
import { Form } from "react-router-dom"
import Button from "react-bootstrap/Button"
import { Card, Container, ListGroup } from "react-bootstrap"
import QRCode from "react-qr-code"
import { useCsrf } from "../contexts/use"


function TemplateEntry({ template }: Readonly<{ template: Template }>) {
  const { id, players, name } = template
  const csrfToken = useCsrf()

  return (
    <ListGroup.Item>
      <Form method="post">
        {/* <span>{name} ({players} Spieler) </span> */}
        <input type="hidden" name="csrf_token" value={csrfToken} />
        <input type="hidden" name="id" value={id} />
        <Button type="submit">{name} ({players} Spieler)</Button>
      </Form>
    </ListGroup.Item>
  )
}

function Templates({ list }: { list: Template[] }) {
  return (
    <div>
      <h2>Vorlagen</h2>
      <p>Die folgenden Vorlagen sind verfügbar:</p>
      {
        list.length ?
          <ListGroup>
            {
              list.map((t: Template) => <TemplateEntry key={t.id} template={t} />)
            }
          </ListGroup>
          :
          <p><i>Keine Vorlagen</i></p>
      }
    </div >
  )
}

function TanCard({ tan }: { tan: string }) {
  return (
    <Card className="d-flex m-1">
      <QRCode value={tan} className="align-self-center p-3" />
      <Card.Body>
        <Card.Title className="text-center">{tan}</Card.Title>
      </Card.Body>
    </Card >
  )
}

interface ActionData {
  id: number,
  tans: string[]
}

function isActionData(obj: unknown): obj is ActionData {
  if (typeof obj !== "object") return false
  const t = obj as ActionData
  return t.id !== undefined && t.tans !== undefined
}

function Execution() {
  const result = useActionData()
  if (!isActionData(result)) {
    throw Error("The action data for the execution is in the wrong format")
  }
  return (
    <div>
      <h2>Ausführung</h2>
      <p>ID: {result.id}</p>
      <p>TANs:</p>
      <Container fluid className="d-flex flex-wrap">
        {result.tans.map(t => <TanCard key={t} tan={t} />)}
      </Container>
    </div>
  )
}

export default function Scenario() {
  const loaderData = useLoaderData() as { templates: Array<Template> }
  const startResult = useActionData()
  // if ("templates" in loaderData) {
  //   return <div>Loading...</div>
  // }
  const { templates } = loaderData
  return (
    <div>
      {startResult ? <Execution /> : <Templates list={templates} />}
    </div>
  )
}

Scenario.loader = async function () {
  const templates = await getTemplates()
  return { templates: templates }
}

Scenario.action = async function ({ request }: ActionFunctionArgs<Request>) {
  const formData = await request.formData()
  const result = await startScenario(formData)
  return result
}

