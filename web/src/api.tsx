export interface Template {
  id: number,
  name: string,
  players: number
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function isTemplate(obj: any): obj is Template {
  return (
    typeof obj.id === "number" &&
    typeof obj.name === "string" &&
    typeof obj.players === "number"
  )
}

export async function getTemplates(): Promise<Template[]> {
  const response = await fetch("/api/templates")
  const templates = await response.json()
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}

export async function startScenario(id: number) {
  const response = await fetch("/api/scenario/start", { method: "POST", body: JSON.stringify({ id: id }) })
  return response
  if (response.ok) {
    console.log(response)
  } else {
    console.error(response)
  }
}

export async function getCsrfToken() {
  const response = await fetch("/api/csrf")
  const json = await response.json()
  console.log(response)
  return json.csrf
}

