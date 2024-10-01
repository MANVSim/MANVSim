import { getStorageItem } from "../services/storage";
import { ExecutionData } from "../types"
import { api, tryFetchApi, tryFetchJson } from "./utils"

export async function postActivateExecution(id: number): Promise<Response> {
  const formData = new FormData()
  formData.append("id", `${id}`)
  const token = getStorageItem("token");
  
  return await fetch(api + "execution/activate", {
    method: "POST",
    body: formData,
    headers: {
      "Authorization": `Bearer ${token}`
    }
  })
}

export async function getActiveExecutions(): Promise<ExecutionData[]> {
  const activeExecutions =
    await tryFetchJson<ExecutionData[]>(`execution/active`)
  if (Array.isArray(activeExecutions)) {
    return activeExecutions
  }
  throw Error(`Could not load active executions!`)
}

export async function getExecution(id: string | undefined): Promise<ExecutionData> {
  const result = tryFetchJson<ExecutionData>(`execution?id=${id}`)
  return result
}

export async function changeExecutionStatus(
  id: number,
  new_status: string,
): Promise<Response> {
  const formData = new FormData()
  formData.append("new_status", new_status)
  return tryFetchApi(`execution?id=${id}`, {
    method: "PATCH",
    body: formData,
  })
}

export async function pushNotificationToPlayer(formData: FormData): Promise<Response> {
   return tryFetchApi(`notifications/post`, {
    method: "POST",
    body: formData,
  })
}