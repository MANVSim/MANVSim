import {
  ActionFunctionArgs,
  Navigate,
  redirect,
  useActionData,
  useLocation,
} from "react-router-dom"
import { Button, Collapse, Form as FormBS } from "react-bootstrap"
import { tryFetchApi } from "../api"
import { setStorageItem } from "../services/storage"
import { ReactElement } from "react"
import { CsrfForm } from "../components/CsrfForm"
import { isLoggedIn } from "../services/auth"

import "./login.css"

export function LoginRoute(): ReactElement {
  const { state } = useLocation()
  const error = useActionData() as string

  if (isLoggedIn()) {
    return <Navigate replace to="/" />
  }

  return (
    <div className="row h-50 justify-content-center align-items-center">
      <div className="col-12 position-at-25">
        <div className="d-flex justify-content-center m-3">
          <h1>MANVSim</h1>
        </div>
        <CsrfForm className="login-form m-auto m-3" method="post">
          <FormBS.Group className="my-3" controlId="formGroupUsername">
            <FormBS.Label>Benutzername</FormBS.Label>
            <FormBS.Control
              required
              type="text"
              placeholder="Benutzername"
              name="username"
              autoComplete="username"
            />
          </FormBS.Group>
          <FormBS.Group controlId="formGroupPassword">
            <FormBS.Label>Passwort</FormBS.Label>
            <FormBS.Control
              required
              type="password"
              placeholder="Passwort"
              name="password"
            />
          </FormBS.Group>
          <div className="d-grid gap-2">
            <Button type="submit" className="my-3">
              Einloggen
            </Button>
          </div>
          <Collapse in={!!state || !!error}>
            <div className="bg-danger p-3 mb-2 rounded-3 text-white">
              {state ?? error}
            </div>
          </Collapse>
        </CsrfForm>
      </div>
    </div>
  )
}

LoginRoute.action = async function ({
  request,
}: ActionFunctionArgs<Request>): Promise<string | Response> {
  const formData = await request.formData()
  const response = await tryFetchApi("login", {
    method: "POST",
    body: formData,
  })
  if (response.status === 401) {
    return "Nutzer oder Passwort ist falsch"
  }

  const json = (await response.json()) as { token: string; username: string }
  if (!("token" in json) || !("username" in json)) {
    throw new Error("Login request returned unknown data")
  }

  setStorageItem("token", json.token)
  setStorageItem("user", json.username)

  return redirect("/")
}
