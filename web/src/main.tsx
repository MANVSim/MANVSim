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
        loader: async () => await getTemplates(),
        action: async ({ request }) => {
          const formData = await request.formData()
          const data = Object.fromEntries(formData)
          return fetch("/api/scenario/start", { method: "POST", body: JSON.stringify(data) })
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
