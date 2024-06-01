import React from 'react'
import ReactDOM from 'react-dom/client'
import {
  createBrowserRouter,
  RouterProvider,
} from 'react-router-dom'
import Root from './routes/root'
import ErrorPage from './error-page'
import Scenario from './routes/scenario'
import { getTemplates } from './api'

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
          const templates = await getTemplates()
          return templates
        },
        action: async ({ request }) => {
          const formData = await request.formData()
          console.log(formData) // TODO: WARUM LEER??
          return fetch("/api/scenario/start", { method: "POST", body: JSON.stringify(formData) })
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
