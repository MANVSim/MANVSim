import { ReactElement } from "react"
import { Form } from "react-bootstrap"
import { State } from "../types"

interface StateSelectorProps {
  states: Record<string, State>
  current: string
}

export function StateSelector({
  states,
  current,
}: StateSelectorProps): ReactElement {
  return (
    <Form.Select>
      {Object.values(states).map((state: State): ReactElement => {
        return <option key={state.uuid}>{state.uuid}</option>
      })}
    </Form.Select>
  )
}
