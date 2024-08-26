import React from "react"
import ReactDOM from "react-dom/client"

// import bootstrap css _before_ all other components so they can overwrite styles
import "bootstrap/dist/css/bootstrap.min.css"

import { createBrowserRouter, RouterProvider } from "react-router-dom"
import { ErrorPage } from "./routes/error-page"
import { Root } from "./routes/root"
import { ExecutionListRoute } from "./routes/executionList"
import { IndexRoute } from "./routes"
import { LoginRoute } from "./routes/login"
import { CsrfProvider } from "./contexts/csrf"
import { AuthProvider } from "./contexts/auth"
import { ExecutionRoute } from "./routes/execution"
import { BaseDataRoute } from "./routes/base-data"
import { ScenarioEditor } from "./routes/scenario-editor"

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <IndexRoute />,
      },
      {
        path: "/executions",
        element: <ExecutionListRoute />,
        loader: ExecutionListRoute.loader,
        action: ExecutionListRoute.action,
      },
      {
        path: "/execution/:executionId",
        element: <ExecutionRoute />,
        loader: ExecutionRoute.loader,
        action: ExecutionRoute.action,
      },
      {
        path: "/scenario/:scenarioId",
        element: <ScenarioEditor />,
        loader: ScenarioEditor.loader,
        action: ScenarioEditor.action
      },
      {
        path: "/data",
        element: <BaseDataRoute />,
        loader: BaseDataRoute.loader
      }
    ],
  },
  {
    path: "/login",
    element: <LoginRoute />,
    action: LoginRoute.action,
  },
])

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <CsrfProvider>
      <AuthProvider>
        <RouterProvider router={router} />
      </AuthProvider>
    </CsrfProvider>
  </React.StrictMode>,
)
