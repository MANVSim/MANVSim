import { getStorageItem } from "./storage"

export function isLoggedIn(): boolean {
  return getStorageItem("token") !== null
}
