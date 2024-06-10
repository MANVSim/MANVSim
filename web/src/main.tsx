import React from 'react'
import ReactDOM from 'react-dom/client'
import {
  createBrowserRouter,
  redirect,
  RouterProvider,
} from 'react-router-dom'
import Root from './routes/root'
import ErrorPage from './error-page'
import Scenario from './routes/scenario'
import { getCsrfToken, getTemplates, startScenario } from './api'
import Index from './routes'
import 'bootstrap/dist/css/bootstrap.min.css';
import Login from './routes/login'
import { CsrfProvider } from './components/csrf'
import { AuthProvider } from './contexts/Auth'


const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      {
        index: true,
        element: <Index />
      },
      {
        path: "/scenario",
        element: <Scenario />,
        loader: async () => {
          const csrfToken = await getCsrfToken()
          const templates = await getTemplates()
          return { csrfToken: csrfToken, templates: templates }
        },
        action: async ({ request }) => {
          const formData = await request.formData()
          const result = await startScenario(formData)
          return result
        }
      },
    ]
  },
  {
    path: "/login",
    element: <Login />,
    action: async ({ request }) => {
      const formData = await request.formData()
      const response = await fetch("/api/web/login", { method: "POST", body: formData })
      if ([401, 404].includes(response.status)) {
        return "Nutzer oder Passwort ist falsch"
      }

      const json = await response.json() as { token: string }
      if (json.token === undefined) {
        throw new Error("Login request returned unknown data")
      }

      localStorage.setItem("token", json.token)

      return redirect("/")
    }
  }
])

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <CsrfProvider>
      <AuthProvider>
        <RouterProvider router={router} />
      </AuthProvider>
    </CsrfProvider>
  </React.StrictMode>,
)
