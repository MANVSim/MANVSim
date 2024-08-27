import {
  ActionFunctionArgs,
  redirect,
  useLoaderData,
  useNavigate,
} from "react-router"
import { getActiveExecutions, getTemplates, tryFetchJson } from "../api"
import { Accordion } from "react-bootstrap"
import { ExecutionData, Scenario, Template } from "../types"
import { ReactElement } from "react"
import { TemplateEntry } from "../components/templateEntry"

import "./executionList.css"

type ExecutionsLoaderData = {
  templates: Array<Template>
  activeExecutions: Array<ExecutionData>
}

export function ExecutionListRoute(): ReactElement {
  const loaderData = useLoaderData() as ExecutionsLoaderData
  const { templates, activeExecutions } = loaderData
  const navigate = useNavigate()

  const handleNewScenario = async () => {
    try {
      const response = await fetch("/web/scenario", { method: "POST" })
      if (response.ok) {
        const response_json = await response.json()
        navigate(`/scenario/${response_json.id}`)
      } else {
        console.error('Failed to create scenario');
      }
    } catch (error) {
      console.error('Error:', error);
    }
  }
  return (
    <div className="mt-3 pb-5">
      <div>
        <h2>Aktive Ausführungen</h2>
        <p>Die folgenden Ausführungen sind gestartet:</p>
        {activeExecutions.length ? (
          <div className="mb-5">
            {activeExecutions.map((item) => (
              <li className="d-flex border p-1 flex-row" key={item.id}>
                <div id="active-execution-name" className="ms-2 me-auto d-flex">
                  <span className="align-self-center">{item.name}</span>
                </div>
                <div id="active-execution-status" className=" d-flex">
                  <span
                    className="align-self-center"
                    style={{ color: getColor(item.status) }}
                  >
                    {item.status}
                  </span>
                </div>
                <div
                  id="active-execution-button-manage"
                  className="ms-5 d-flex"
                >
                  <button
                    className="btn btn-secondary me-2 align-self-center"
                    onClick={() => navigate(`/execution/${item.id}`)}
                  >
                    Verwalten
                  </button>
                </div>
              </li>
            ))}
          </div>
        ) : (
          <p>
            <i>Es sind derzeit keine Scenarios aktiv.</i>
          </p>
        )}
      </div>
      <div className="pt-3 border-top">
        <div className="d-flex justify-content-between">
          <div>
            <h2>Vorlagen</h2>
            <p>Die folgenden Vorlagen sind verfügbar:</p>
          </div>
          <div className="d-flex">
            <button
              className="btn btn-outline-primary ps-5 pe-5 align-self-end mb-3"
              onClick={handleNewScenario}
            >
              Neu
            </button>
          </div>
        </div>
        {templates.length ? (
          <Accordion>
            {templates.map((t: Template, index: number) => (
              <TemplateEntry key={t.id} template={t} index={index} />
            ))}
          </Accordion>
        ) : (
          <p>
            <i>Keine Vorlagen</i>
          </p>
        )}
      </div>
    </div>
  )
}

ExecutionListRoute.loader = async function (): Promise<{
  templates: Template[]
  activeExecutions: ExecutionData[]
}> {
  const templates = await getTemplates()
  const activeExecutions = await getActiveExecutions()
  return { templates, activeExecutions }
}

ExecutionListRoute.action = async function ({
  request,
}: ActionFunctionArgs<Request>) {
  const formData = await request.formData()
  const id_json = await tryFetchJson<ExecutionData>("execution/create", {
    body: formData,
    method: "POST",
  })
  if (id_json.id) {
    return redirect(`/execution/${id_json.id}`)
  } else {
    alert(`No execution created due to input/db error.`)
    return redirect("/executions")
  }
}

function getColor(status: string) {
  switch (status) {
    case "PENDING":
      return "orange"
    case "RUNNING":
      return "green"
    case "FINISHED":
      return "red"
    default:
      return "black"
  }
}
