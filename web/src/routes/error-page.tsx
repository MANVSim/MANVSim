import { useRouteError } from "react-router-dom"
import { ReactElement } from "react"

export function ErrorPage(): ReactElement {
  const error = useRouteError()
  console.error(error)
  return <div>Ein Fehler ist aufgetreten</div>
  // logout()
  // return (
  //   <Navigate
  //     replace
  //     to="/login"
  //     state={`Login ist ausgelaufen! Bitte erneut anmelden!`}
  //   />
  // )
}
