import { faSave } from "@fortawesome/free-solid-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { PropsWithChildren, ReactElement, useEffect, useState } from "react"
import {
  Button,
  CloseButton,
  Image,
  Modal,
  Tab,
  Table,
  Tabs,
} from "react-bootstrap"
import { tryFetchJson } from "../api"

function Attribute({ name, children }: PropsWithChildren<{ name: string }>) {
  return (
    <tr>
      <td>{name}</td>
      <td>{children}</td>
    </tr>
  )
}

function getFileType(file: string): string {
  const [, , , type] = file.split("/")
  return type
}

function Media({ file }: { file: string }): ReactElement {
  const server = import.meta.env.VITE_SERVER_URL
  return (
    <div>
      <Image style={{ height: "50px" }} src={`${server}/${file}`} />
      <div>{file}</div>
    </div>
  )
}

function MediaData() {
  const [tab, setTab] = useState("text")

  // Get all available data paths from server
  const [data, setData] = useState<Map<string, Array<string>> | null>(null)
  useEffect(() => {
    tryFetchJson<string[]>("media/all").then((data) => {
      const d = new Map<string, string[]>()
      for (const f of data) {
        const type = getFileType(f)
        d.set(type, (d.get(type) ?? []).concat(f))
        setData(d)
      }
    })
  }, [])

  return (
    <div>
      <Table borderless>
        <tbody>
          <Attribute name="Titel">
            <input />
          </Attribute>
          <Attribute name="Text">
            <input />
          </Attribute>
          <tr>
            <td colSpan={2}>
              <div>Referenz</div>
              <div>
                <Tabs
                  activeKey={tab}
                  fill
                  justify
                  onSelect={(k) => setTab(k ?? "text")}
                >
                  <Tab title="Text" eventKey="text"></Tab>
                  <Tab title="Bild" eventKey="image"></Tab>
                  <Tab title="Video" eventKey="video"></Tab>
                  <Tab title="Audio" eventKey="audio"></Tab>
                </Tabs>
                <div style={{ maxHeight: "50vh", overflow: "auto" }}>
                  {data &&
                    (data.get(tab) ?? []).map((f: string) => {
                      return <Media key={f} file={f} />
                    })}
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </Table>
    </div>
  )
}

export default function MediaEditor() {
  const [show, setShow] = useState(true)
  function close() {
    setShow(false)
  }
  return (
    <Modal show={show} centered size="lg">
      <Modal.Header>
        <h4>Mediaeditor</h4>
        <CloseButton onClick={close} />
      </Modal.Header>
      <Modal.Body>
        <MediaData />
      </Modal.Body>
      <Modal.Footer>
        <Button>
          <FontAwesomeIcon icon={faSave} />
        </Button>
      </Modal.Footer>
    </Modal>
  )
}
