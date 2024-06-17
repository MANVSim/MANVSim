import {
  ReactNode,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react"
import { getCsrfToken } from "../api"

export const CsrfContext = createContext("")

export function CsrfInput() {
  const csrfToken = useContext(CsrfContext)
  return <input type="hidden" value={csrfToken} name="csrf_token" />
}

export function CsrfProvider({ children }: { children: ReactNode }) {
  const [csrfToken, setCsrfToken] = useState("")
  useEffect(() => {
    getCsrfToken().then((token) => setCsrfToken(token))
  }, [])
  return (
    <CsrfContext.Provider value={csrfToken}>{children}</CsrfContext.Provider>
  )
}
