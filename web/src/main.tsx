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
import { getCsrfToken, getTemplates } from './api'

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
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
          const response = await fetch("/api/scenario/start", { method: "POST", body: formData })
          const json = await response.json()
          if (!response.ok) {
            return {
              message: `${response.status}: ${response.statusText} (${json.error})`
            }
          }
          const executionId = json.id
          return redirect(`/execution/${executionId}`)
        }
      }
    ]
  },
])

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
)
