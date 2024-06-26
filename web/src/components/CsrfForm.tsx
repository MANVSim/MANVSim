import { Form } from "react-router-dom"
import { CsrfInput } from "../contexts/csrf"
import { PropsWithChildren, ReactElement } from "react"

export default function CsrfForm({
  children,
  ...props
}: PropsWithChildren): ReactElement {
  return (
    <Form {...props}>
      <CsrfInput />
      {children}
    </Form>
  )
}
