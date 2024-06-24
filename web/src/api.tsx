import { redirect } from "react-router"
import { getStorageItem } from "./storage"
import {
  Template,
  isTemplate,
  isCsrfToken,
  StartResponse,
  isStartResponse,
  isLoginResponse,
} from "./types"

const api = "/web/"

export async function tryFetchApi(
  url: string,
  body: RequestInit = {},
): Promise<Response> {
  const apiRequest = new Request(api + url, body)
  apiRequest.headers.append("Content-Type", "application/json")
  const token = getStorageItem("token")
  if (token) {
    apiRequest.headers.append("Authorization", `Bearer ${token}`)
  }
  return fetch(apiRequest)
}

export async function tryFetchJson(
  url: string,
  body: RequestInit = {},
): Promise<object> {
  const response = await tryFetchApi(url, body)
  return response.json()
}

export async function getTemplates(): Promise<Template[]> {
  const templates = await tryFetchJson("templates")
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}

export async function getCsrfToken(): Promise<string> {
  const json = await tryFetchJson("csrf")
  if (!isCsrfToken(json)) {
    throw new Error("Fetched json does not contain a CSRF Token!")
  }
  return json.csrf_token
}

export async function startScenario(
  formData: FormData,
): Promise<StartResponse> {
  const json = await tryFetchJson("scenario/start", {
    method: "POST",
    body: formData,
  })
  if (!isStartResponse(json)) {
    throw new Error("Unexpected response")
  }
  return json
}

export async function getAuthToken(
  formData: FormData,
): Promise<string | Response> {
  const response = await fetch(api + "login", {
    method: "POST",
    body: formData,
  })
  if ([401, 404].includes(response.status)) {
    return "Nutzer oder Passwort ist falsch"
  }

  const json = await response.json()
  if (!isLoginResponse(json)) {
    throw new Error("Login request returned unknown data")
  }

  return redirect("/")
}

export async function getExecutionStatus(id: string): Promise<object> {
  return tryFetchJson(`execution/${id}`)
}

export async function startExecution(
  id: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(`execution/${id}/start`, {
    method: "POST",
    body: formData,
  })
}

export async function stopExecution(
  id: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(`execution/${id}/stop`, {
    method: "POST",
    body: formData,
  })
}

export async function togglePlayerStatus(
  executionId: string,
  playerTan: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(`execution/${executionId}/player/${playerTan}/status`, {
    method: "POST",
    body: formData,
  })
}
