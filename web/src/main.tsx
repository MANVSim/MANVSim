import React from "react"
import ReactDOM from "react-dom/client"
import { createBrowserRouter, RouterProvider } from "react-router-dom"
import Root from "./routes/root"
import ErrorPage from "./error-page"
import Scenario from "./routes/scenario"
import Index from "./routes"
import "bootstrap/dist/css/bootstrap.min.css"
import Login from "./routes/login"
import { CsrfProvider } from "./contexts/csrf"
import { AuthProvider } from "./contexts/auth"
import Execution from "./routes/execution"

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <Index />,
      },
      {
        path: "/scenario",
        element: <Scenario />,
        loader: Scenario.loader,
      },
      {
        path: "/execution/create",
        action: Scenario.action
      },
      {
        path: "/execution/:executionId",
        element: <Execution />,
        loader: Execution.loader,
        action: Execution.action,
      },
    ],
  },
  {
    path: "/login",
    element: <Login />,
    action: Login.action,
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
