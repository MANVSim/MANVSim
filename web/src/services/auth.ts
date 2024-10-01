import { deleteStorageItem, getStorageItem } from "./storage"

export function isLoggedIn(): boolean {
  return getStorageItem("token") !== null
}

export function logout() {
  deleteStorageItem("token")
  deleteStorageItem("user")
}
