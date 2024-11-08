import { ChangeEvent, ReactElement } from "react"
import { Form } from "react-bootstrap"
import { State } from "../types"

type PartialState = Pick<State, "uuid" | "name">

interface StateSelectorProps {
  states: Record<string, PartialState>
  current: string
  update(new_value: string): void
}

export function StateSelector({
  states,
  current,
  update,
}: StateSelectorProps): ReactElement {
  return (
    <Form.Select
      value={current}
      onChange={(event: ChangeEvent<HTMLSelectElement>): void => {
        update(event.target.value)
      }}
    >
      {Object.values(states).map((state: PartialState): ReactElement => {
        return <option key={state.uuid}>{state.name}</option>
      })}
    </Form.Select>
  )
}
