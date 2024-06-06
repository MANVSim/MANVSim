// https://www.robinwieruch.de/react-router-authentication/
import { ReactNode, createContext, useState } from "react";

const AuthContext = createContext("")

export function useAuth() {
  return useState(AuthContext)
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authToken, setAuthToken] = useState("")
  return (
    <AuthContext.Provider value={authToken}>
      {children}
    </AuthContext.Provider>
  )
}
