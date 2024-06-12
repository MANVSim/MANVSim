// https://www.robinwieruch.de/react-router-authentication/
import { Dispatch, ReactNode, SetStateAction, createContext, useState } from "react";

type Nullable<T> = T | null
type NullableString = Nullable<string>
export type SetAuthTokenType = Dispatch<SetStateAction<NullableString>>

interface AuthValue {
  authToken: NullableString,
  setAuthToken: SetAuthTokenType
}

export const AuthContext = createContext<Nullable<AuthValue>>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [authToken, setAuthToken] = useState<NullableString>(null)
  return (
    <AuthContext.Provider value={{ authToken, setAuthToken }} >
      {children}
    </AuthContext.Provider >
  )
}
