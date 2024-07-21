import { useState } from "react"
import { NavigateFunction, useNavigate } from "react-router"
import { Template } from "../types"
import {
  AccordionBody,
  AccordionHeader,
  AccordionItem,
  Form as FormBS,
} from "react-bootstrap"
import { CsrfForm } from "./CsrfForm"
import { postActivateExecution } from "../api"

import "./templateEntry.css"

export function TemplateEntry({
  template,
  index,
}: Readonly<{ template: Template; index: number }>) {
  const navigate = useNavigate()
  const { name, executions } = template
  const [isVisible, setIsVisible] = useState(false)
  const [isAccordionOpen, setIsAccordionOpen] = useState(false)
  const [formDataTemp, setFormData] = useState({
    scenario_id: -1, // Initial value for scenario_id
    name: "", // Initial value for name
  })

  const handleButtonClick = (event: { stopPropagation: () => void }) => {
    if (isAccordionOpen) {
      event.stopPropagation() // Prevents the click event from bubbling up
    }
    setIsAccordionOpen(true)
    setIsVisible(!isVisible)
  }

  const handleOpenAccordion = () => {
    setIsAccordionOpen(!isAccordionOpen)
  }

  return (
    <AccordionItem eventKey={index.toString()}>
      <AccordionHeader
        onClick={handleOpenAccordion}
        aria-expanded={isAccordionOpen}
      >
        <div className="d-flex justify-content-between w-100">
          <div className="d-flex align-items-center">
            <span>{name}</span>
          </div>
          <div className="me-3">
            <button
              id="add-btn"
              className="btn btn-outline-primary btn-sm"
              onClick={handleButtonClick}
            >
              +
            </button>
          </div>
        </div>
      </AccordionHeader>
      <AccordionBody>
        {executions.length ? (
          executions.map(({ name, id }) => (
            <li key={id} className="w-100 d-flex mb-2">
              <button
                id="lobby-hover"
                className="btn btn-light flex-fill me-2 d-flex justify-content-center"
                onClick={() => navigate(`/execution/${id}`)}
              >
                <div className="align-self-center">{name}</div>
              </button>
              <div className="w-25">
                <button
                  className="btn btn-success me-2 w-100"
                  onClick={() => activateExecution(id, navigate)}
                >
                  <svg
                    id="execution-play-icon"
                    xmlns="http://www.w3.org/2000/svg"
                    width="16"
                    height="16"
                    fill="currentColor"
                    className="bi bi-play-fill d-none"
                    viewBox="0 0 16 16"
                  >
                    <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393" />
                  </svg>
                  <span className="execution-play-text">Aktivieren</span>
                </button>
              </div>
            </li>
          ))
        ) : (
          <div className="fw-light fst-italic">Keine Ausführungen</div>
        )}
        <CsrfForm
          className={`d-flex mt-2 ${isVisible ? "" : "d-none"}`}
          method="post"
          action="/execution/create"
        >
          <FormBS.Group className="d-none" controlId="formGroupScenarioId">
            <FormBS.Label>Scenario-ID</FormBS.Label>
            <FormBS.Control
              required
              type="integer"
              name="scenario_id"
              value={template.id}
              onChange={(e) =>
                setFormData({
                  ...formDataTemp,
                  scenario_id: parseInt(e.target.value),
                })
              }
              readOnly
            />
          </FormBS.Group>
          <li className="w-100 d-flex mb-2">
            <FormBS.Group className="flex-fill me-2" controlId="formGroupName">
              <FormBS.Control
                required
                type="text"
                placeholder="Name der Execution"
                name="name"
                onChange={(e) =>
                  setFormData({ ...formDataTemp, name: e.target.value })
                }
              />
            </FormBS.Group>
            <div className="w-25">
              <button className="btn btn-primary w-100" type="submit">
                <svg
                  id="execution-save-icon"
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  fill="currentColor"
                  className="bi bi-check d-none"
                  viewBox="0 0 16 16"
                >
                  <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425z" />
                </svg>
                <span id="execution-save-text">Erstellen</span>
              </button>
            </div>
          </li>
        </CsrfForm>
      </AccordionBody>
    </AccordionItem>
  )
}

async function activateExecution(exec_id: number, navigate: NavigateFunction) {
  const response = postActivateExecution(exec_id)

  if ([200, 201].includes((await response).status)) {
    navigate(`/execution/${exec_id}`)
  } else {
    console.error(
      "Unable to start execution. Response status:",
      (await response).status,
    )
    throw new Error("Unable to start execution.")
  }
}
