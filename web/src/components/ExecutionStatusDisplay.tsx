import { useEffect } from "react"
import { changeExecutionStatus } from "../api"
import { ExecutionData } from "../types"
import type { ExecutionStatus } from "../types"
import { StatusIcon } from "./StatusIcon"
import { Button } from "react-bootstrap"

export type ExecutionStatusProps = {
  execution: ExecutionData,
  status: ExecutionStatus,
  setStatus: React.Dispatch<React.SetStateAction<ExecutionStatus>>,
}

export function ExecutionStatusDisplay({ execution, status, setStatus }: ExecutionStatusProps) {

  useEffect(() => {
    setStatus(status)
  }, [execution, status, setStatus])

  return (
    <div className="border-bottom border-dark border-2 pb-3">
      <div className="d-flex mt-5">
        <span className="fs-4">Aktueller Status:</span>
        <div className="d-flex ms-3 align-items-center">
          <StatusIcon status={status} />
        </div>
        <div className="ms-auto ms-3">
          <Button
            className={`${status == "UNKNOWN" || status == "FINISHED" ? "" : "d-none"} btn-success`}
            onClick={() => {
              setStatus("PENDING")
              changeExecutionStatus(execution.id, "PENDING")
            }}
          >
            <svg
              id="btn-activate-icon"
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              className="bi bi-upload d-none"
              viewBox="0 0 16 16"
            >
              <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5" />
              <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z" />
            </svg>
            <span id="btn-activate-text">Aktivieren</span>
          </Button>
          <Button
            className={`${status == "PENDING" ? "" : "d-none"}`}
            onClick={() => {
              setStatus("RUNNING")
              changeExecutionStatus(execution.id, "RUNNING")
            }}
          >
            <svg
              id="btn-play-icon"
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              className="bi bi-play-fill d-none"
              viewBox="0 0 16 16"
            >
              <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393" />
            </svg>
            <span id="btn-play-text">Starten</span>
          </Button>
          <Button
            className={`${status == "RUNNING" ? "" : "d-none"} btn-warning`}
            onClick={() => {
              setStatus("PENDING")
              changeExecutionStatus(execution.id, "PENDING")
            }}
          >
            <svg
              id="btn-pause-icon"
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              className="bi bi-pause-fill d-none"
              viewBox="0 0 16 16"
            >
              <path d="M5.5 3.5A1.5 1.5 0 0 1 7 5v6a1.5 1.5 0 0 1-3 0V5a1.5 1.5 0 0 1 1.5-1.5m5 0A1.5 1.5 0 0 1 12 5v6a1.5 1.5 0 0 1-3 0V5a1.5 1.5 0 0 1 1.5-1.5" />
            </svg>
            <span id="btn-pause-text">Pause</span>
          </Button>
          <Button
            className={`${status == "RUNNING" ? "" : "d-none"} btn-danger ms-2`}
            onClick={() => {
              setStatus("FINISHED")
              changeExecutionStatus(execution.id, "FINISHED")
            }}
          >
            <svg
              id="btn-stop-icon"
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              className="bi bi-stop-fill d-none"
              viewBox="0 0 16 16"
            >
              <path d="M5 3.5h6A1.5 1.5 0 0 1 12.5 5v6a1.5 1.5 0 0 1-1.5 1.5H5A1.5 1.5 0 0 1 3.5 11V5A1.5 1.5 0 0 1 5 3.5" />
            </svg>
            <span id="btn-stop-text">Stoppen</span>
          </Button>
        </div>
      </div>
    </div>
  )
}
