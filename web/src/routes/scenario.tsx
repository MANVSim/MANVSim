import { useActionData, useLoaderData } from "react-router"
import { Template } from "../api"
import { Form } from "react-router-dom"
import Button from "react-bootstrap/Button"
import { Card, ListGroup, Row } from "react-bootstrap"

interface LoaderData {
  csrfToken: string,
  templates: Template[]
}

function isLoaderData(obj: unknown): obj is LoaderData {
  return (obj as LoaderData).templates !== undefined
}

function TemplateEntry({ template, csrfToken }: Readonly<{ template: Template, csrfToken: string }>) {
  const { id, players, name } = template
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

function Templates({ list, csrfToken }: { list: Template[], csrfToken: string }) {
  return (
    <div>
      <h2>Vorlagen</h2>
      <p>Die folgenden Vorlagen sind verfügbar:</p>
      {
        list.length ?
          <ListGroup>
            {
              list.map((t: Template) => <TemplateEntry key={t.id} template={t} csrfToken={csrfToken} />)
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
    <Card style={{ width: '10rem' }}>
      <Card.Img variant="top" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/QR_deWP.svg/330px-QR_deWP.svg.png" />
      <Card.Body>
        <Card.Title className="text-center">{tan}</Card.Title>
      </Card.Body>
    </Card>
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
      <Row xs={1} md={2} className="g-4">
        {result.tans.map(t => <TanCard key={t} tan={t} />)}
      </Row>
    </div>
  )
}

export default function Scenario() {
  const loaderData = useLoaderData()
  const startResult = useActionData()
  if (!isLoaderData(loaderData)) {
    return <div>Loading...</div>
  }
  const { csrfToken, templates } = loaderData
  return (
    <div>
      {startResult ? <Execution /> : <Templates list={templates} csrfToken={csrfToken} />}
    </div>
  )
}
