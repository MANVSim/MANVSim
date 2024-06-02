import { useActionData, useLoaderData } from "react-router"
import { Template, isTemplate } from "../api"
import { Form } from "react-router-dom"

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
  return !!obj?.message
}

function TemplateEntry({ template, csrfToken }: { template: Template, csrfToken: string }) {
  const { id, players, name } = template
  return (
    <Form method="post">
      <span>{name} ({players} Spieler) </span>
      <input type="hidden" name="csrf_token" value={csrfToken} />
      <input type="hidden" name="id" value={id} />
      <button type="submit">Starten</button>
    </Form>
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
        Array.isArray(templates) && templates.every(isTemplate) ?
          templates.length ?
            <ul>
              {
                templates.map((t: Template) => <TemplateEntry key={t.id} template={t} csrfToken={csrfToken} />)
              }
            </ul>
            :
            <p><i>Keine Vorlagen</i></p>
          :
          <div>
            Fehler beim Laden
          </div>
      }
    </div>
  )
}
