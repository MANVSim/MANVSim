import { Action } from "../types"
import { tryFetchJson } from "./utils"

export function getActions(): Promise<Action[]> {
  return tryFetchJson<Action[]>("data/action/all")
}
