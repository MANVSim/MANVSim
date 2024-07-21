import { useContext } from "react"
import { AuthContext } from "../contexts/auth"
import { AuthValue, Nullable } from "../types"
import { CsrfContext } from "../contexts/csrf"

export function useAuth(): Nullable<AuthValue> {
  return useContext(AuthContext)
}

export function useCsrf(): string {
  return useContext(CsrfContext)
}
