import ReactCodeMirror from "@uiw/react-codemirror"
import { ReactElement, useCallback, useState } from "react"
import { yaml } from "@codemirror/lang-yaml"

export default function StateRoute(): ReactElement {
  const [value, setValue] = useState("key: value\nkey2: value2\nkey3: value3\n")
  const onChange = useCallback((val: string) => {
    console.log("val:", val)
    setValue(val)
  }, [])
  return (
    <ReactCodeMirror value={value} onChange={onChange} extensions={[yaml()]} />
  )
}
