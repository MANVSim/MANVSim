// https://www.robinwieruch.de/react-router-authentication/
import { ReactNode, useState } from "react";
import { AuthContext } from "./AuthContext";

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authToken] = useState("")
  return (
    < AuthContext.Provider value={authToken} >
      {children}
    </AuthContext.Provider >
  )
}
