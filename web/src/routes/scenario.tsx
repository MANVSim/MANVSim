import { useLoaderData } from "react-router"
import { getTemplates, isTemplate } from "../api"
export async function loader() {
  const templates = await getTemplates()
  return templates
}

export default function Scenario() {
  const templates = useLoaderData()
  return (
    <div>
      <h2>Vorlagen</h2>
      <p>Die folgenden Vorlagen sind verfügbar:</p>
      {
        Array.isArray(templates) && templates.every(isTemplate) ?
          templates.length ?
            <ul>
              {
                templates.map(t => (
                  <li key={t.id}>{t.name} ({t.players} Spieler)</li>
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
