import { Form, FormProps } from "react-router-dom"
import { CsrfInput } from "../contexts/csrf"
import { PropsWithChildren, ReactElement } from "react"

export function CsrfForm({
  children,
  ...props
}: PropsWithChildren<FormProps>): ReactElement {
  return (
    <Form {...props}>
      <CsrfInput />
      {children}
    </Form>
  )
}
