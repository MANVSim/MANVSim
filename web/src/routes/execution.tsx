import {
  Button,
  Collapse,
  Container,
  FloatingLabel,
  Form,
  FormLabel,
} from "react-bootstrap"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
  useParams,
} from "react-router"
import { useEffect, useState } from "react"
import _ from "lodash"
import { config } from "../config"
import {
  Player,
  ExecutionData,
  isExecutionData,
  Role,
  Location,
  Notifications,
  ExecutionStatus,
} from "../types"
import { CsrfForm } from "../components/CsrfForm"
import { getExecution, togglePlayerStatus, createNewPlayer, pushNotificationToPlayer, deletePlayer } from "../api"
import { TanCard } from "../components/TanCard"
import { PlayerStatus } from "../components/PlayerStatus"
import { ExecutionStatusDisplay } from "../components/ExecutionStatusDisplay"

import "./executionList"
import "./execution.css"
import QRCode from "react-qr-code"
import { redirect } from "react-router-dom";

export function ExecutionRoute() {
  const executionData = useLoaderData() as ExecutionData

  const [execution, setExecution] = useState<ExecutionData>(executionData)
  const [status, setStatus] = useState<ExecutionStatus>(execution.status)

  const [open, setOpen] = useState(false)
  const [notificationDisplay, setNotificationDisplay] = useState(false)
  const [lastSent, setLastSent] = useState<Notifications>({ text: "empty", timestamp: "empty" })

  useEffect(() => {
    const notificationLength = execution.notifications.length;
    if (notificationLength > 0) {
      setLastSent(execution.notifications[notificationLength - 1]);
    }
  }, [execution.notifications]);  // This effect will run only when execution.notifications changes

  const [tansAvailable, tansUsed] = _.partition(
    execution?.players,
    (player: Player): boolean => player.name === null,
  )

  const { executionId } = useParams<{ executionId: string }>()

  useEffect(() => {
    if (isExecutionData(executionData)) {
      setExecution(executionData)
    }
  }, [executionData])

  useEffect(() => {
    const intervalId = setInterval(async () => {
      if (typeof executionId === "undefined" ||
        (status !== "PENDING" && status !== "RUNNING")
      ) {
        return
      }

      const updatedState = await getExecution(executionId)

      if (isExecutionData(updatedState)) {
        setExecution(updatedState)
      }
    }, config.pollingRate)
    return () => clearInterval(intervalId)
  }, [executionId, status])

  return (
    <div>
      {execution ? (
        <div>
          <h2 id="execution-name-header" className="align-self-center mt-3">
            {execution.name} (#{executionId})
          </h2>
          <ExecutionStatusDisplay execution={execution} status={status} setStatus={setStatus} />
          <div id="add-new-player" className="d-grid border rounded mt-3">
            <Button
              className={`rounded ${open ? "btn-light" : "btn-primary"}`}
              onClick={() => setOpen(!open)}
            >
              {open ? (
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  fill="currentColor"
                  className="bi bi-caret-up-fill"
                  viewBox="0 0 16 16"
                >
                  <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                </svg>
              ) : (
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-person-plus" viewBox="0 0 16 16">
                  <path d="M6 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H1s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C9.516 10.68 8.289 10 6 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                  <path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5" />
                </svg>
              )}
            </Button>
            <Collapse in={open}>
              <div>
                <CsrfForm method="POST" className="d-grid gap-2 p-3">
                  <input type="hidden" name="id" value="new-player" />
                  <FloatingLabel label="Rolle">
                    <Form.Select name="role">
                      {execution.roles.map((role: Role) => {
                        return (
                          <option key={role.id} value={role.id}>
                            {role.name}
                          </option>
                        )
                      })}
                    </Form.Select>
                  </FloatingLabel>
                  <FloatingLabel label="Ort">
                    <Form.Select name="vehicle">
                      {execution.locations.map((location: Location) => {
                        return (
                          <option key={location.id} value={location.name}>
                            {location.name}
                          </option>
                        )
                      })}
                    </Form.Select>
                  </FloatingLabel>
                  <Button type="submit">Neuen Spieler erstellen</Button>
                </CsrfForm>
              </div>
            </Collapse>
          </div>
          <section className="mt-3">
            <h3>Verfügbare Spieler-TANs:</h3>
            <Container fluid className="d-flex flex-wrap justify-content-center my-3">
              {tansAvailable.length ? (
                tansAvailable.map((player) => (
                  <div className="m-1 w-25 align-self-start">
                    <TanCard key={player.tan} player={player} />
                    <CsrfForm method="POST" className="my-2">
                      <input name="id" value={"delete-player"} hidden />
                      <input type="text" name="tan" value={player.tan} hidden />
                      <input type="text" name="vehicle" value={player.location?.name} hidden />
                      <button className="btn btn-outline-danger w-100">Löschen</button>
                    </CsrfForm>
                  </div>
                ))
              ) : (
                <span>
                  Erstelle neue Spieler um weitere TANs verfügbar zu haben.
                </span>
              )}
            </Container>
          </section>
          <section
            id="active-tan-player-table"
            className="overflow-scroll w-100"
          >
            <h3 className="mt-5">Aktive Spieler:</h3>
            {execution.players.length > 0 ? (
              <table id="active-tan-player" className="table">
                <thead>
                  <tr>
                    <th>TAN</th>
                    <th>Status</th>
                    <th>Name</th>
                    <th>Rolle</th>
                    <th>Ort</th>
                  </tr>
                </thead>
                <tbody>
                  {tansUsed.map((player) => (
                    <PlayerStatus key={player.tan} player={player} exec_status={execution.status} />
                  ))}
                </tbody>
              </table>
            ) : (
              <div>Es sind noch keine Spieler registriert.</div>
            )}
          </section>
          <section id="notification-input" className="mt-3">
            <CsrfForm id="notification-input-form" method="POST" className="d-flex flex-column mb-3">
              <div className="d-flex mt-2">
                <FormLabel className="fs-5 mt-2 me-4">Nachrichten</FormLabel>
                <div className="d-flex justify-content-center ms-auto">
                  <Button className={`align-self-center ${execution.status == "PENDING" || execution.status == "RUNNING" ? "" : "disabled"}`} type="submit">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16" height="16"
                      fill="currentColor"
                      className="bi bi-send"
                      viewBox="0 0 16 16"
                    >
                      <path d="M15.854.146a.5.5 0 0 1 .11.54l-5.819 14.547a.75.75 0 0 1-1.329.124l-3.178-4.995L.643 7.184a.75.75 0 0 1 .124-1.33L15.314.037a.5.5 0 0 1 .54.11ZM6.636 10.07l2.761 4.338L14.13 2.576zm6.787-8.201L1.591 6.602l4.339 2.76z" />
                    </svg>
                  </Button>
                </div>
              </div>
              <input type="hidden" name="id" value="post-notification" />
              <textarea className="mr-2 mt-2" name="notification" form="notification-input-form" rows={2} cols={120} required></textarea>
            </CsrfForm>
          </section>
          <section id="notification-display">
            <div className="d-flex flex-row">
              {execution.notifications.length > 0 ? (
                <div className={`mt-2 mb-2 pb-2 d-flex w-75`}>
                  <div className="w-50">
                    {notificationDisplay ? "Gesendete Nachrichten:" : `Zuletzt gesendet (${lastSent.timestamp})`}
                  </div>
                  <div className={notificationDisplay ? "invisible" : ""}>
                    {lastSent.text}
                  </div>
                </div>
              ) : (
                <li className="list-group-item">Es wurden noch keine Nachrichten gesendet.</li>
              )}
              <div className="d-flex justify-content-center ms-auto">
                <Button
                  className={`rounded btn-light align-self-center`}
                  onClick={() => setNotificationDisplay(!notificationDisplay)}
                >
                  {notificationDisplay ? (
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      fill="currentColor"
                      className="bi bi-caret-up-fill"
                      viewBox="0 0 16 16"
                    >
                      <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
                    </svg>
                  ) : (
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      fill="currentColor"
                      className="bi bi-caret-down-fill"
                      viewBox="0 0 16 16"
                    >
                      <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
                    </svg>
                  )}
                </Button>
              </div>
            </div>
            <ol className={`mb-3 ${notificationDisplay ? "" : "d-none"} list-group`}>
              {execution.notifications.map((notification) => (
                <li className="list-group-item d-flex flex-row">
                  <div className="w-25">
                    {notification.timestamp}
                  </div>
                  <div>
                    {notification.text}
                  </div>
                </li>
              ))}
            </ol>
          </section>
          <section id="patient-qrcodes" className={`d-flex flex-wrap w-100 mt-3 justify-content-evenly ${execution.status === "RUNNING" || execution.status === "PENDING" ? "" : "d-none"}`}>
            <div className="w-100">
              <h3>Patienten</h3>
            </div>
            {execution.patients.length ? (execution.patients.map((patient, index) => (
              <div key={index} className={`d-flex flex-column m-2 p-2`}>
                <span>Name: {patient.name}</span>
                <span>#{patient.id}</span>
                <QRCode value={`patient;${patient.id}`} />
              </div>
            ))
            ) : (
              <span>
                Das Scenario hat keine Patienten gespeichert.
              </span>
            )}

          </section>
        </div>
      ) : (
        <div>Loading...</div>
      )}
    </div>
  )
}

ExecutionRoute.loader = async function ({
  params: { executionId },
}: LoaderFunctionArgs) {
  return getExecution(executionId)
}

ExecutionRoute.action = async function ({
  params,
  request,
}: ActionFunctionArgs) {
  if (params.executionId === undefined) return null
  const formData = await request.formData()
  const id = formData.get("id")
  formData.delete("id")

  switch (id) {
    case "post-notification": {
      formData.append("exec_id", params.executionId)
      const response = await pushNotificationToPlayer(formData)
      if (response.ok) {
        return redirect(`/execution/${params.executionId}`);
      } else {
        console.error('Failed to send notification:', response.text());
        return null;
      }

    }
    case "player-status": {
      const playerTan = formData.get("tan") as string | null
      if (playerTan === null) return null
      formData.delete("tan")
      return togglePlayerStatus(params.executionId, playerTan, formData)
    }
    case "new-player": {

      const response = await createNewPlayer(params.executionId, formData)
      // Instead of redirecting, reload the current page
      if (response.ok) {
        return redirect(`/execution/${params.executionId}`);
      } else {
        console.error('Failed to create player:', response.text());
        return null;
      }
    }
    case "delete-player": {

      const response = await deletePlayer(params.executionId, formData)
      // Instead of redirecting, reload the current page
      if (response.ok) {
        return redirect(`/execution/${params.executionId}`);
      } else {
        console.error('Failed to delete player:', response.text());
        return null;
      }
    }
    default:
      throw new Error(`Case '${id}' is not covered in Execution.action`)
  }
}
