import ReactCodeMirror from "@uiw/react-codemirror"
import { ReactElement, useCallback, useState } from "react"
import { yaml } from "@codemirror/lang-yaml"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getPatient } from "../api"
import { Patient, isPatient } from "../types"

export default function StateRoute(): ReactElement {
  const loaderData = useLoaderData()
  const [value, setValue] = useState(loaderData)
  const onChange = useCallback((val: string) => {
    setValue(val)
  }, [])
  return (
    <ReactCodeMirror
      value={isPatient(value) ? value.activity_diagram : ""}
      onChange={onChange}
      extensions={[yaml()]}
    />
  )
}

StateRoute.loader = async function ({
  params,
}: LoaderFunctionArgs): Promise<Patient> {
  const id = params.patientId
  if (id === undefined) {
    throw new Error("No patient ID provided")
  }
  const patient = await getPatient(id)
  return patient
}
