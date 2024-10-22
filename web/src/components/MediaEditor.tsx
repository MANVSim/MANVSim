import { PropsWithChildren, ReactElement, useEffect, useState } from "react"
import {
  Button,
  Image,
  ListGroup,
  ListGroupItemProps,
  Tab,
  Table,
  Tabs,
} from "react-bootstrap"
import { tryFetchJson } from "../api"
import { Condition } from "../types"

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

interface MediaProps extends ListGroupItemProps {
  file: string
}

function Media({ file, ...props }: MediaProps): ReactElement {
  const server = import.meta.env.VITE_SERVER_URL
  return (
    <ListGroup.Item
      {...props}
      as="button"
      className="text-start d-flex gap-1 align-items-center"
    >
      <Image style={{ height: "50px" }} src={`${server}/${file}`} />
      <div>{file}</div>
    </ListGroup.Item>
  )
}

interface MediaDataProps {
  data: Condition
}

function MediaData({ data }: MediaDataProps): ReactElement {
  const [tab, setTab] = useState("")

  // Get all available data paths from server
  const [availableMedia, setAvailableMedia] = useState<Map<
    string,
    Array<string>
  > | null>(null)
  useEffect(() => {
    tryFetchJson<string[]>("media/all").then((data) => {
      const d = new Map<string, string[]>()
      for (const f of data) {
        const type = getFileType(f)
        d.set(type, (d.get(type) ?? []).concat(f))
        setAvailableMedia(d)
      }
    })
  }, [])

  return (
    <div>
      <Table borderless>
        <tbody>
          <Attribute name="Titel">
            <input value={data.title ?? ""} />
          </Attribute>
          <Attribute name="Text">
            <input value={data.text ?? ""} />
          </Attribute>
          <tr>
            <td colSpan={2}>
              <div>Referenz</div>
              <div>
                <Tabs
                  activeKey={tab}
                  fill
                  justify
                  onSelect={(k) => setTab(k ?? "")}
                >
                  <Tab title="Keine" eventKey=""></Tab>
                  <Tab title="Text" eventKey="text"></Tab>
                  <Tab title="Bild" eventKey="image"></Tab>
                  <Tab title="Video" eventKey="video"></Tab>
                  <Tab title="Audio" eventKey="audio"></Tab>
                </Tabs>
                <ListGroup
                  style={{ maxHeight: "20em", overflow: "auto" }}
                  activeKey={data.media_reference ?? ""}
                >
                  {availableMedia &&
                    (availableMedia.get(tab) ?? []).map((f: string) => {
                      return (
                        <Media
                          key={f}
                          file={f}
                          active={f.endsWith(data.media_reference ?? "")}
                        />
                      )
                    })}
                </ListGroup>
              </div>
            </td>
          </tr>
        </tbody>
      </Table>
    </div>
  )
}

interface MediaEditorProps {
  mediaArray: Condition[]
  setMediaArray: (mediaArray: Condition[]) => void
}

export default function MediaEditor({
  mediaArray,
  // setMediaArray,
}: MediaEditorProps): ReactElement {
  return (
    <div>
      {mediaArray.map((media: Condition, i: number) => {
        return <MediaData key={i} data={media} />
      })}
    </div>
  )
}
