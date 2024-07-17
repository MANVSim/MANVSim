import "./execution.css"
import {
  Button,
  Collapse,
  Container,
  FloatingLabel,
  Form,
} from "react-bootstrap"
import {
  ActionFunctionArgs,
  LoaderFunctionArgs,
  useLoaderData,
  useParams,
} from "react-router"
import { ReactElement, useEffect, useState } from "react"
import _ from "lodash"
import { config } from "../config"
import {
  Player,
  ExecutionData,
  isExecutionData,
  Role,
  Location,
} from "../types"
import { CsrfForm } from "../components/CsrfForm"
import { getExecution, togglePlayerStatus, createNewPlayer } from "../api"
import { TanCard } from "../components/TanCard"
import { PlayerStatus } from "../components/PlayerStatus"
import { ExecutionStatus } from "../components/ExecutionStatus"

export function ExecutionRoute(): ReactElement {
  const loaderData = useLoaderData()

  const [execution, setExecution] = useState<null | ExecutionData>(
    isExecutionData(loaderData) ? loaderData : null,
  )

  const [open, setOpen] = useState(false)

  const [tansAvailable, tansUsed] = _.partition(
    execution?.players,
    (player: Player): boolean => player.name === null,
  )

  const { executionId } = useParams<{ executionId: string }>()

  useEffect(() => {
    if (isExecutionData(loaderData)) {
      setExecution(loaderData)
    }
  }, [loaderData])

  useEffect(() => {
    const intervalId = setInterval(async () => {
      if (typeof executionId === "undefined") {
        return
      }

      const status = await getExecution(executionId)

      if (isExecutionData(status)) {
        setExecution(status)
      }
    }, config.pollingRate)
    return () => clearInterval(intervalId)
  }, [executionId])

  return (
    <div>
      {execution ? (
        <div>
          <h2 id="execution-name-header" className="align-self-center mt-3">
            {execution.name}-{executionId}
          </h2>
          <ExecutionStatus execution={execution} />
          <div className="d-grid border rounded mt-3">
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
                "Weiteren Spieler hinzufügen"
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
                    <Form.Select name="location">
                      {execution.locations.map((location: Location) => {
                        return (
                          <option key={location.id} value={location.id}>
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
          <section>
            <h3>Verfügbare TANs:</h3>
            <Container fluid className="d-flex flex-wrap my-3">
              {tansAvailable.length ? (
                tansAvailable.map((player) => (
                  <TanCard key={player.tan} player={player} />
                ))
              ) : (
                <span>
                  Erstelle neue Spieler um neue Tans verfügbar zu haben.
                </span>
              )}
            </Container>
          </section>
          <section
            id="active-tan-player-table"
            className="overflow-scroll w-100"
          >
            <h3 className="mt-5">Aktive TANs:</h3>
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
                  <PlayerStatus key={player.tan} player={player} />
                ))}
              </tbody>
            </table>
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
  if (executionId === undefined) return null
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
    case "player-status": {
      const playerTan = formData.get("tan") as string | null
      if (playerTan === null) return null
      formData.delete("tan")
      return togglePlayerStatus(params.executionId, playerTan, formData)
    }
    case "new-player":
      return createNewPlayer(params.executionId, formData)
    default:
      throw new Error(`Case '${id}' is not covered in Execution.action`)
  }
}
