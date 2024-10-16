import { Navigate, useRouteError } from "react-router-dom"
import { logout } from "../services/auth"

export function ErrorPage() {
  const error = useRouteError()
  console.error(error)
  // logout()
  // return (
  //   <Navigate
  //     replace
  //     to="/login"
  //     state={`Login ist ausgelaufen! Bitte erneut anmelden!`}
  //   />
  // )
}
