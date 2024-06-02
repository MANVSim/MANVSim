import { useActionData, useLoaderData } from "react-router"
import { Template } from "../api"
import { Form } from "react-router-dom"
import Button from "react-bootstrap/Button"
import { ListGroup } from "react-bootstrap"

interface LoaderData {
  csrfToken: string,
  templates: Template[]
}

function isLoaderData(obj: unknown): obj is LoaderData {
  return (obj as LoaderData).templates !== undefined
}

interface FetchError {
  message: string
}

function isFetchError(obj: unknown): obj is FetchError {
  return !!(obj as FetchError)?.message
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

export default function Scenario() {
  const loaderData = useLoaderData()
  const fetchError = useActionData()
  if (!isLoaderData(loaderData)) {
    return <div>Loading...</div>
  }
  const { csrfToken, templates } = loaderData
  return (
    <div>
      <h2>Vorlagen</h2>
      {isFetchError(fetchError) && <p>{fetchError.message}</p>}
      <p>Die folgenden Vorlagen sind verfügbar:</p>
      {
        templates.length ?
          <ListGroup>
            {
              templates.map((t: Template) => <TemplateEntry key={t.id} template={t} csrfToken={csrfToken} />)
            }
          </ListGroup>
          :
          <p><i>Keine Vorlagen</i></p>
      }
    </div >
  )
}
