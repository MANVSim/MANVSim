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
import StateRoute from "./routes/patient/state"
import { BaseDataRoute } from "./routes/base-data"
import { ScenarioEditor } from "./routes/scenario-editor"
import { ToastContainer } from "react-toastify"
import "react-toastify/dist/ReactToastify.css"

const router = createBrowserRouter(
  [
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
          path: "/data/patient/:patientId",
          element: <StateRoute />,
          loader: StateRoute.loader,
          action: StateRoute.action,
          errorElement: <ErrorPage />,
        },
        {
          path: "/scenario/:scenarioId",
          element: <ScenarioEditor />,
          loader: ScenarioEditor.loader,
          action: ScenarioEditor.action,
        },
        {
          path: "/data/:windowId",
          element: <BaseDataRoute />,
          loader: BaseDataRoute.loader,
          action: BaseDataRoute.action,
        },
      ],
    },
    {
      path: "/login",
      element: <LoginRoute />,
      action: LoginRoute.action,
    },
  ],
  {
    basename: "/admin",
  },
)

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <CsrfProvider>
      <AuthProvider>
        <RouterProvider router={router} />
        <ToastContainer position="bottom-right" autoClose={5000} />
      </AuthProvider>
    </CsrfProvider>
  </React.StrictMode>,
)
