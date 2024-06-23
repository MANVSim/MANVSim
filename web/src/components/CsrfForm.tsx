import { Form, FormProps } from "react-router-dom"
import { CsrfInput } from "../contexts/csrf"
import { ReactElement, ReactNode } from "react"

export default function CsrfForm({
  children,
  ...props
}: FormProps & { children?: ReactNode }): ReactElement {
  return (
    <Form {...props}>
      <CsrfInput />
      {children}
    </Form>
  )
}
