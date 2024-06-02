export interface Template {
  id: number,
  name: string,
  players: number
}

function isTemplate(obj: object): obj is Template {
  const template = obj as Template
  return !!template?.id && !!template?.name && !!template?.players
}

interface CsrfToken {
  csrf: string
}

function isCsrfToken(obj: object): obj is CsrfToken {
  return !!(obj as CsrfToken)?.csrf
}


async function tryFetch(url: string): Promise<Response> {
  const response = await fetch(url)
  if (!response.ok) {
    throw new Error(`Could not fetch ${url}: ${response.status}: ${response.statusText}`)
  }
  return response
}

async function tryFetchJson(url: string): Promise<object> {
  const response = await tryFetch(url)
  return await response.json()
}

export async function getTemplates(): Promise<Template[]> {
  const templates = await tryFetchJson("/api/templates")
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}

export async function getCsrfToken() {
  const json = await tryFetchJson("/api/csrf")
  if (!isCsrfToken(json)) {
    throw new Error("Fetched json does not contain a CSRF Token!")
  }
  return json.csrf
}

