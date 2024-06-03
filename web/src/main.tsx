import React from 'react'
import ReactDOM from 'react-dom/client'
import {
  createBrowserRouter,
  RouterProvider,
} from 'react-router-dom'
import Root from './routes/root'
import ErrorPage from './error-page'
import Scenario from './routes/scenario'
import { getCsrfToken, getTemplates, startScenario } from './api'
import Index from './routes'

import 'bootstrap/dist/css/bootstrap.min.css';

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
      }
    ]
  },
])

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
)
