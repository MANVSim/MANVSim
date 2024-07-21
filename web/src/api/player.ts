import { tryFetchApi } from "./utils"

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
