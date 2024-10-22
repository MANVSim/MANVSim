import { faSave } from "@fortawesome/free-solid-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { PropsWithChildren, useEffect, useState } from "react"
import { Button, CloseButton, Modal, Tab, Table, Tabs } from "react-bootstrap"
import { tryFetchJson } from "../api"

function Attribute({ name, children }: PropsWithChildren<{ name: string }>) {
  return (
    <tr>
      <td>{name}</td>
      <td>{children}</td>
    </tr>
  )
}

function MediaData() {
  const [tab, setTab] = useState("text")

  // Get all available data paths from server
  const [data, setData] = useState<string[] | null>(null)
  useEffect(() => {
    tryFetchJson<string[]>("media/all").then((data) => {
      setData(data)
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
                <div>
                  {data &&
                    data.map((f: string) => {
                      return <div>{f}</div>
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
