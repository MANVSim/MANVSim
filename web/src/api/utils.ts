import { getStorageItem } from "../services/storage"

export const api = import.meta.env.VITE_API_URL;

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
  if ([401].includes(response.status)){
    throw Error("Unauthorized request detected.")
  }
  return response.json()
}
