
import { useState } from "react"
import { BaseDataStripped, Media } from "../types"
import "./mediaUpload.css"
import { CsrfForm } from "./CsrfForm"

interface MediaUploadProps {
    data: BaseDataStripped
    className: string,
    uploadView: boolean,
    setUploadView: React.Dispatch<React.SetStateAction<boolean>>,
    dataType: string
}

const MediaUpload: React.FC<MediaUploadProps> = ({ data, className = '', uploadView, setUploadView, dataType }) => {
    const [fileView, setFileView] = useState(true)
    const [isText, setIsText] = useState("ntxt")
    const [deleteMediaList, setDeleteMediaList] = useState<Media[]>([])

    // Function to compare two media objects based on their properties
    const isSameMedia = (media1: Media, media2: Media) => {
        return (
            media1.media_type === media2.media_type &&
            media1.title === media2.title &&
            media1.text === media2.text &&
            media1.media_reference === media2.media_reference
        );
    };

    // Function to check if a media is in the delete list
    const isMediaInDeleteList = (media: Media) => {
        return deleteMediaList.some((deletedMedia) => isSameMedia(deletedMedia, media));
    };

    return (
        <section id="media-upload-section" className={`${uploadView ? "" : "d-none"} ${className}`}>
            <div id="upload-header" className="d-flex mb-3">
                <h1 className="fs-4 text-white">Beschreibungseditor: {data.name}-{data.id}</h1>
                <button className="btn btn-danger ms-auto" onClick={() => {
                    setUploadView(false)
                    setDeleteMediaList([])
                }
                }>Abbrechen</button>

            </div>
            <CsrfForm id="media-upload-form" method="post" encType="multipart/form-data">
                <input type="text" name="dataType" value={dataType} hidden readOnly />
                <input type="text" name="type" value={isText} hidden readOnly />
                <input type="text" name="id" value={data.id} hidden readOnly />

                <div id="media-upload" className="bg-white rounded p-2 border-bottom">
                    <div className="btn-group mb-2" role="group" aria-label="Basic radio toggle button group">
                        <input type="radio" className="btn-check" name="fileView" id="btnradio1" autoComplete="off" checked={fileView} onClick={() => {
                            setFileView(true)
                            setIsText("ntxt")
                        }
                        } />
                        <label className="btn btn-outline-primary" htmlFor="btnradio1">Datei</label>

                        <input type="radio" className="btn-check" name="fileView" id="btnradio2" autoComplete="off" checked={!fileView} onClick={() => {
                            setFileView(false)
                            setIsText("txt")
                        }
                        } />
                        <label className="btn btn-outline-primary" htmlFor="btnradio2">Text</label>
                    </div>
                    <div id="upload-row" className="d-flex pb-2">
                        <input type="text" id="media-title" className={`form-control me-2`} name="title" placeholder="Title" />
                        <input type="file" name="file" id="media-file-input" className={`form-control ${fileView ? "" : "d-none"}`} />
                        <button className="btn btn-primary ms-2" type="submit">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-upload" viewBox="0 0 16 16">
                                <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5" />
                                <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z" />
                            </svg>
                        </button>
                    </div>
                    <label className={`${fileView ? "d-none" : ""}`}>Beschreibungstext</label>
                    <textarea className={`me-2 ${fileView ? "d-none" : ""}`} rows={2} cols={120} name="text" form="media-upload-form" />
                </div>
            </CsrfForm>
            <section id="current-media-files-table" className="mt-2 p-2 rounded bg-white">
                <CsrfForm id="media-upload-form" method="patch">
                    <input type="text" name="formType" value="delete" hidden readOnly />
                    <input type="text" name="dataType" value={dataType} hidden readOnly />
                    <input type="hidden" name="media_refs_del" value={JSON.stringify(deleteMediaList)} />
                    <input type="text" name="id" value={data.id} hidden readOnly />
                    <div id="upload-header" className="d-flex mb-3">
                        <h1 className="fs-5 mb-3">Gespeicherte Medien</h1>
                        <button className="btn btn-primary ms-auto" type="submit">Speichern</button>
                    </div>
                    <div className="table-container">
                        <table className="table">
                            <thead className="sticky-header">
                                <tr>
                                    <th scope="col">Media-Typ</th>
                                    <th scope="col">Titel</th>
                                    <th scope="col">Text</th>
                                    <th scope="col">Referenz</th>
                                </tr>
                            </thead>
                            <tbody className="">
                                {data.media_refs === undefined ?
                                    <tr>
                                        <td>
                                            No data to display
                                        </td>
                                    </tr> : JSON.parse(data.media_refs).map((media: Media, index: number) => (
                                        <tr key={index} className={`${isMediaInDeleteList(media) ? "d-none" : ""}`}>
                                            <td> {media.media_type || "Ohne Typ"}</td>
                                            <td> {media.title || "Ohne Titel"}</td>
                                            <td> {media.text || "Kein Text"}</td>
                                            <td> {media.media_reference || "Kein Link gespeichert"}</td>
                                            <td className="ms-3 btn btn-outline-danger btn-sm w-50" onClick={() => {
                                                if (!isMediaInDeleteList(media)) {
                                                    setDeleteMediaList([...deleteMediaList, media]);
                                                }
                                            }}
                                            >-</td>
                                        </tr>))
                                }
                            </tbody>
                        </table>
                    </div>
                </CsrfForm>
            </section>
        </section>
    )
}

export default MediaUpload;