import { PropsWithChildren, ReactElement, useEffect, useState } from "react"
import {
  Image,
  ListGroup,
  ListGroupItemProps,
  Tab,
  Table,
  Tabs,
} from "react-bootstrap"
import { tryFetchJson } from "../api"
import { Condition } from "../types"
import { last } from "lodash"

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
  updateData: (updateFnc: (draft: Condition) => void) => void
}

function MediaData({ data, updateData }: MediaDataProps): ReactElement {
  const [tab, setTab] = useState(getFileType(data.media_reference ?? ""))

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
            <input
              value={data.title ?? ""}
              onChange={(event) => {
                updateData((draft) => {
                  draft.title = event.target.value
                })
              }}
            />
          </Attribute>
          <Attribute name="Text">
            <input
              value={data.text ?? ""}
              onChange={(event) => {
                updateData((draft) => {
                  draft.text = event.target.value
                })
              }}
            />
          </Attribute>
          <tr>
            <td colSpan={2}>
              <div>Referenz</div>
              <div>
                <Tabs
                  activeKey={tab}
                  fill
                  justify
                  onSelect={(k) => {
                    updateData((draft) => {
                      draft.media_reference = null
                    })
                    setTab(k ?? "")
                  }}
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
                          active={f === data.media_reference?.substring(0)}
                          onClick={() => {
                            updateData((draft) => {
                              draft.media_reference = f
                            })
                          }}
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
  updateMediaArray: (updateFnc: (draft: Condition[]) => void) => void
}

export default function MediaEditor({
  mediaArray,
  updateMediaArray,
}: MediaEditorProps): ReactElement {
  return (
    <div>
      {mediaArray.map((media: Condition, i: number) => {
        return (
          <MediaData
            key={i}
            data={media}
            updateData={(updateFnc) => {
              updateMediaArray((draft) => {
                updateFnc(draft[i])
              })
            }}
          />
        )
      })}
    </div>
  )
}
