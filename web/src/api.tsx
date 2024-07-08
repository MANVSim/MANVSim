import { redirect } from "react-router"
import { getStorageItem } from "./storage"
import {
  Template,
  isTemplate,
  isCsrfToken,
  isLoginResponse,
  CsrfToken,
  ExecutionData,
  isExecutionData,
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

export async function tryFetchJson<T = object>(
  url: string,
  body: RequestInit = {},
): Promise<T> {
  const response = await tryFetchApi(url, body)
  return response.json()
}

export async function getTemplates(): Promise<Template[]> {
  const templates = await tryFetchJson<Template[]>("templates")
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}

export async function getCsrfToken(): Promise<string> {
  const json = await tryFetchJson<CsrfToken>("csrf")
  if (!isCsrfToken(json)) {
    throw new Error("Fetched json does not contain a CSRF Token!")
  }
  return json.csrf_token
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
export async function postActivateExecution(id: number): Promise<Response> {
  const formData = new FormData()
  formData.append("id", `${id}`)

  return await fetch(api + "execution/activate", {
    method: "POST",
    body: formData,
  })
}
export async function getActiveExecutions(): Promise<ExecutionData[]> {
  const activeExecutions = await tryFetchJson<ExecutionData[]>(`execution/active`)
  if (Array.isArray(activeExecutions)) {
    return activeExecutions
  }
  throw Error(`Could not load active executions!`)
}

export async function getExecution(id: string): Promise<ExecutionData> {
  const result = tryFetchJson<ExecutionData>(`execution?id=${id}`)
  return result
}

export async function changeExecutionStatus(
  id: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(`execution?id=${id}`, {
    method: "PATCH",
    body: formData,
  })
}

export async function togglePlayerStatus(
  executionId: string,
  playerTan: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(
    `execution/player/status?id=${executionId}&tan=${playerTan}`,
    {
      method: "PATCH",
      body: formData,
    },
  )
}

export async function createNewPlayer(
  executionId: string,
  formData: FormData,
): Promise<Response> {
  return tryFetchApi(`execution?id=${executionId}`, {
    method: "POST",
    body: formData,
  })
}
