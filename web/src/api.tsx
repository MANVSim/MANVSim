import { redirect } from "react-router"
import { isType } from "./utils"

const api = "/web/"

export interface Template {
  id: number,
  name: string,
  players: number
}

function isTemplate(obj: object): obj is Template {
  return isType<Template>(obj, "players", "name", "id")
}

interface CsrfToken {
  csrf_token: string
}

function isCsrfToken(obj: object): obj is CsrfToken {
  return isType<CsrfToken>(obj, "csrf_token")
}

export async function tryFetchApi(url: string, body: RequestInit = {}): Promise<Response> {
  const apiRequest = new Request(api + url, body)
  apiRequest.headers.append("Content-Type", "application/json")
  const token = localStorage.getItem("token")
  if (token) {
    apiRequest.headers.append("Authorization", `Bearer ${token}`)
  }
  return await fetch(apiRequest)
}

export async function tryFetchJson(url: string, body = {}): Promise<object> {
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
  id: number
}

function isStartResponse(obj: object): obj is StartResponse {
  return isType<StartResponse>(obj, "id")
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
  return isType<LoginResponse>(obj, "token")
}

export async function getAuthToken(formData: FormData): Promise<string | Response> {
  const response = await fetch(api + "login", { method: "POST", body: formData })
  if ([401, 404].includes(response.status)) {
    return "Nutzer oder Passwort ist falsch"
  }

  const json = await response.json()
  if (!isLoginResponse(json)) {
    throw new Error("Login request returned unknown data")
  }

  return redirect("/")
}

export async function getExecutionStatus(id: string) {
  const json = await tryFetchJson(`execution/${id}`)
  return json
}

export async function startExecution(id: string, formData: FormData) {
  return await tryFetchJson(`execution/${id}/start`, { method: "POST", body: formData })
}

export async function stopExecution(id: string, formData: FormData) {
  return await tryFetchJson(`execution/${id}/stop`, { method: "POST", body: formData })
}
