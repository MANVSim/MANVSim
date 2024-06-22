import { useContext } from "react"
import { AuthContext } from "./auth"
import { CsrfContext } from "./csrf"
import { AuthValue, Nullable } from "../types"

export function useAuth(): Nullable<AuthValue> {
  return useContext(AuthContext)
}

export function useCsrf(): string {
  return useContext(CsrfContext)
}
