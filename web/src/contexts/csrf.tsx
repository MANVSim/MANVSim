import {
  ReactElement,
  ReactNode,
  createContext,
  useContext,
  useEffect,
  useState,
} from "react"
import { getCsrfToken } from "../api"
import { config } from "../config"

export const CsrfContext = createContext("")

export function CsrfInput(): ReactElement {
  const csrfToken = useContext(CsrfContext)
  return <input type="hidden" value={csrfToken} name="csrf_token" />
}

export function CsrfProvider({
  children,
}: {
  children: ReactNode
}): ReactElement {
  const [csrfToken, setCsrfToken] = useState("")
  if (csrfToken == "") getCsrfToken().then((token) => setCsrfToken(token))
  useEffect(() => {
    const intervalId = setInterval(async () => {
      getCsrfToken().then((token) => setCsrfToken(token))
    }, config.csrfPollingRate)
    return () => clearInterval(intervalId)
  }, [])
  return (
    <CsrfContext.Provider value={csrfToken}>{children}</CsrfContext.Provider>
  )
}
