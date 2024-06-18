import { z } from "zod"
import { isType } from "./utils"
import { Dispatch, SetStateAction } from "react"

const template = z.object({
  id: z.number(),
  name: z.string(),
  players: z.number(),
})

export type Template = z.infer<typeof template>

export function isTemplate(obj: unknown): obj is Template {
  return template.safeParse(obj).success
}

export interface CsrfToken {
  csrf_token: string
}

export function isCsrfToken(obj: object): obj is CsrfToken {
  return isType<CsrfToken>(obj, "csrf_token")
}

export interface StartResponse {
  id: number
}

export function isStartResponse(obj: object): obj is StartResponse {
  return isType<StartResponse>(obj, "id")
}

export interface LoginResponse {
  token: string
}

export function isLoginResponse(obj: object): obj is LoginResponse {
  return isType<LoginResponse>(obj, "token")
}

export interface Player {
  tan: string
  name: string
  status: string
  action: string
}

export interface ExecutionData {
  id: number
  status: string
  players: Player[]
}

export function isExecutionData(obj: unknown): obj is ExecutionData {
  return isType<ExecutionData>(obj, "players", "status", "id")
}

export type Nullable<T> = T | null
export type NullableString = Nullable<string>
export type SetAuthTokenType = Dispatch<SetStateAction<NullableString>>

export interface AuthValue {
  authToken: NullableString
  setAuthToken: SetAuthTokenType
}
