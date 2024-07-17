// https://www.robinwieruch.de/react-router-authentication/
import { ReactNode, createContext, useState } from "react"
import { AuthValue, Nullable, NullableString } from "../types"

export const AuthContext = createContext<Nullable<AuthValue>>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authToken, setAuthToken] = useState<NullableString>(null)

  return (
    <AuthContext.Provider value={{ authToken, setAuthToken }}>
      {children}
    </AuthContext.Provider>
  )
}
