const api = "web/"

export interface Template {
  id: number,
  name: string,
  players: number
}

function isTemplate(obj: object): obj is Template {
  const template = obj as Template
  return [template.id, template.name, template.players].every(x => x !== undefined)
}

interface CsrfToken {
  csrf_token: string
}

function isCsrfToken(obj: object): obj is CsrfToken {
  return !!(obj as CsrfToken)?.csrf_token
}

async function tryFetchApi(url: string, body = {}): Promise<Response> {
  const response = await fetch(api + url, body)
  if (!response.ok) {
    throw new Error(`Could not fetch ${url}: ${response.status}: ${response.statusText}`)
  }
  return response
}

async function tryFetchJson(url: string, body = {}): Promise<object> {
  const response = await tryFetchApi(url, body)
  return await response.json()
}

export async function getTemplates(): Promise<Template[]> {
  const templates = await tryFetchJson("templates")
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}

export async function getCsrfToken() {
  const json = await tryFetchJson("csrf")
  if (!isCsrfToken(json)) {
    throw new Error("Fetched json does not contain a CSRF Token!")
  }
  return json.csrf_token
}

interface StartResponse {
  id: number,
  tans: string[]
}

function isStartResponse(obj: object): obj is StartResponse {
  const t = obj as StartResponse
  return t.id !== undefined && t.tans !== undefined
}

export async function startScenario(formData: FormData): Promise<StartResponse> {
  const json = await tryFetchJson("scenario/start", { method: "POST", body: formData })
  if (!isStartResponse(json)) {
    throw new Error("Unexpected response")
  }
  return json
}

interface LoginResponse {
  token: string
}

function isLoginResponse(obj: object): obj is LoginResponse {
  const t = obj as LoginResponse
  return t.token !== undefined
}

export async function getAuthToken(formData: FormData): Promise<string> {
  const json = await tryFetchJson("login", { method: "POST", body: formData })
  if (!isLoginResponse(json)) {
    throw new Error("Response from server to login request failed")
  }
  return json.token
}