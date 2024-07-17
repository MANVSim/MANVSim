import React from "react"
import ReactDOM from "react-dom/client"
import "bootstrap/dist/css/bootstrap.min.css"
import { createBrowserRouter, RouterProvider } from "react-router-dom"
import { ErrorPage } from "./error-page"
import { Root } from "./routes/root"
import { ExecutionsRoute } from "./routes/executions"
import { IndexRoute } from "./routes"
import { LoginRoute } from "./routes/login"
import { CsrfProvider } from "./contexts/csrf"
import { AuthProvider } from "./contexts/auth"
import { ExecutionRoute } from "./routes/execution"

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
        element: <ExecutionsRoute />,
        loader: ExecutionsRoute.loader,
        action: ExecutionsRoute.action,
      },
      {
        path: "/execution/:executionId",
        element: <ExecutionRoute />,
        loader: ExecutionRoute.loader,
        action: ExecutionRoute.action,
      },
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
