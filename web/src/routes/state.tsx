import ReactCodeMirror from "@uiw/react-codemirror"
import { ReactElement, useCallback, useState } from "react"
import { yaml } from "@codemirror/lang-yaml"
import { LoaderFunctionArgs, useLoaderData } from "react-router"
import { getPatient } from "../api"
import { Patient, isPatient } from "../types"
import { default as jsyaml } from "js-yaml"

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
  if (patient.activity_diagram !== undefined) {
    patient.activity_diagram = jsyaml.dump(JSON.parse(patient.activity_diagram))
  }
  return patient
}
