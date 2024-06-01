import { useActionData, useLoaderData } from "react-router"
import { isTemplate } from "../api"
import { Form } from "react-router-dom"

export default function Scenario() {
  const { csrfToken, templates } = useLoaderData()
  const fetchError = useActionData()
  return (
    <div>
      <h2>Vorlagen</h2>
      {fetchError && <p>{fetchError.message}</p>}
      <p>Die folgenden Vorlagen sind verfügbar:</p>
      {
        Array.isArray(templates) && templates.every(isTemplate) ?
          templates.length ?
            <ul>
              {
                templates.map(t => (
                  <Form key={t.id} method="post">
                    <span>{t.name} ({t.players} Spieler) </span>
                    <input type="hidden" name="csrf_token" value={csrfToken} />
                    <input type="hidden" name="id" value={t.id} />
                    <button type="submit">Starten</button>
                  </Form>
                ))
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
