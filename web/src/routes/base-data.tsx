import { ActionFunctionArgs, LoaderFunctionArgs, useLoaderData } from "react-router"
import { getBaseData } from "../api/base-data"
import { BaseDataStripped, Media } from "../types"
import { Button } from "react-bootstrap"
import { useEffect, useMemo, useState } from "react"
import MediaUpload from "../components/mediaUpload"
import {api, tryFetchJson} from "../api"

type BaseData = {
    actions: Array<BaseDataStripped>
    locations: Array<BaseDataStripped>
    resources: Array<BaseDataStripped>
    windowId: string
}

export function BaseDataRoute() {
    const { actions, locations, resources, windowId } = useLoaderData() as BaseData

    const [showActions, setShowActions] = useState(true)
    const [showLocations, setShowLocations] = useState(false)
    const [showResources, setShowResources] = useState(false)


    const emptyBaseData = useMemo(() => {
        return {
            id: 0,
            name: ""
        }
    }, []); // No dependencies, so it's only created once
    const [editData, setEditData] = useState(emptyBaseData)
    const [uploadView, setUploadView] = useState(false)

    const [dataType, setDataType] = useState("")

    useEffect(() => {
        if (windowId !== "all") {
            const windowIdSplit = windowId.split("-")
            const dataType = windowIdSplit[0]
            const id = +windowIdSplit[1]
            if (dataType === "action") {
                setEditData(actions.find(item => item.id === id) ?? emptyBaseData)
            } else if (dataType === "location") {
                setEditData(locations.find(item => item.id === id) ?? emptyBaseData)
            } else if (dataType === "resource") {
                setEditData(resources.find(item => item.id === id) ?? emptyBaseData)
            }
            setUploadView(true)
            setDataType(dataType)
        }
    }, [emptyBaseData, actions, locations, resources, windowId])

    const handlePageNav = (showId: number) => {
        setShowActions(showId === 1);
        setShowLocations(showId === 2);
        setShowResources(showId !== 1 && showId !== 2);
        setUploadView(false)
    }

    return (
        <section>
            <MediaUpload className="bg-secondary position-fixed p-3 rounded w-50" data={editData} uploadView={uploadView} setUploadView={setUploadView} dataType={dataType} />
            <section id="page-nav-section" className="d-flex justify-content-center mt-5">
                <div className="d-flex justify-content-center border-2">
                    <div className={`btn ${showActions ? "active" : ""}`} onClick={() => handlePageNav(1)}>
                        <span>Maßnahmen</span>
                    </div>
                    <div className={`btn ${showLocations ? "active" : ""}`} onClick={() => handlePageNav(2)}>
                        <span>Ressourcenverwahrungsobjekte</span>
                    </div>
                    <div className={`btn ${showResources ? "active" : ""}`} onClick={() => handlePageNav(3)}>
                        <span>Ressourcen</span>
                    </div>
                </div>
            </section>
            <section id="base-data-list-action" className={`${showActions ? "" : "d-none"}`}>
                {actions.length ? (
                    <div className="mt-2">
                        {actions.map((action) => (
                            <li className="btn d-flex border-bottom p-1 flex-row" key={action.id}>
                                <div id="action-icon d-flex">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-hammer mt-2 me-5" viewBox="0 0 16 16">
                                        <path d="M9.972 2.508a.5.5 0 0 0-.16-.556l-.178-.129a5 5 0 0 0-2.076-.783C6.215.862 4.504 1.229 2.84 3.133H1.786a.5.5 0 0 0-.354.147L.146 4.567a.5.5 0 0 0 0 .706l2.571 2.579a.5.5 0 0 0 .708 0l1.286-1.29a.5.5 0 0 0 .146-.353V5.57l8.387 8.873A.5.5 0 0 0 14 14.5l1.5-1.5a.5.5 0 0 0 .017-.689l-9.129-8.63c.747-.456 1.772-.839 3.112-.839a.5.5 0 0 0 .472-.334" />
                                    </svg>
                                </div>
                                <div id="action-name" className="ms-2 me-auto d-flex">
                                    <span className="align-self-center">{action.name}</span>
                                </div>
                                <Button className="btn-primary" onClick={() => {
                                    setEditData(action)
                                    setUploadView(true)
                                    setDataType("action")
                                }
                                }>Bearbeiten</Button>
                            </li>
                        ))}
                    </div>
                ) : (
                    <div className="mt-5 d-flex justify-content-center border-bottom">
                        <p>
                            <i>Es sind keine Maßnahmen gespeichert.</i>
                        </p>
                    </div>
                )}
            </section>
            <section id="base-data-list-location" className={`${showLocations ? "" : "d-none"}`}>
                {locations.length ? (
                    <div className="mt-2">
                        {locations.map((location) => (
                            <li className="btn d-flex border-bottom p-1 flex-row" key={location.id}>
                                <div id="location-icon d-flex">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-bag-fill mt-2 me-5" viewBox="0 0 16 16">
                                        <path d="M8 1a2.5 2.5 0 0 1 2.5 2.5V4h-5v-.5A2.5 2.5 0 0 1 8 1m3.5 3v-.5a3.5 3.5 0 1 0-7 0V4H1v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4z" />
                                    </svg>
                                </div>
                                <div id="location-name" className="ms-2 me-auto d-flex">
                                    <span className="align-self-center">{location.name}</span>
                                </div>
                                <Button className="btn-primary" onClick={() => {
                                    setEditData(location)
                                    setUploadView(true)
                                    setDataType("location")
                                }
                                }>Bearbeiten</Button>
                            </li>
                        ))}
                    </div>
                ) : (
                    <div className="mt-5 d-flex justify-content-center border-bottom">
                        <p>
                            <i>Es sind keine Ressourcenverwahrungsobjekte (RVOs) gespeichert.</i>
                        </p>
                    </div>
                )}
            </section>
            <section id="base-data-list-resource" className={`${showResources ? "" : "d-none"}`}>
                {resources.length ? (
                    <div className="mt-2">
                        {resources.map((resource) => (
                            <li className="btn d-flex border-bottom p-1 flex-row" key={resource.id}>
                                <div id="resource-icon d-flex">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-bandaid-fill mt-2 me-5" viewBox="0 0 16 16">
                                        <path d="m2.68 7.676 6.49-6.504a4 4 0 0 1 5.66 5.653l-1.477 1.529-5.006 5.006-1.523 1.472a4 4 0 0 1-5.653-5.66l.001-.002 1.505-1.492.001-.002Zm5.71-2.858a.5.5 0 1 0-.708.707.5.5 0 0 0 .707-.707ZM6.974 6.939a.5.5 0 1 0-.707-.707.5.5 0 0 0 .707.707M5.56 8.354a.5.5 0 1 0-.707-.708.5.5 0 0 0 .707.708m2.828 2.828a.5.5 0 1 0-.707-.707.5.5 0 0 0 .707.707m1.414-2.121a.5.5 0 1 0-.707.707.5.5 0 0 0 .707-.707m1.414-.707a.5.5 0 1 0-.706-.708.5.5 0 0 0 .707.708Zm-4.242.707a.5.5 0 1 0-.707.707.5.5 0 0 0 .707-.707m1.414-.707a.5.5 0 1 0-.707-.708.5.5 0 0 0 .707.708m1.414-2.122a.5.5 0 1 0-.707.707.5.5 0 0 0 .707-.707M8.646 3.354l4 4 .708-.708-4-4zm-1.292 9.292-4-4-.708.708 4 4z" />
                                    </svg>
                                </div>
                                <div id="resource-name" className="ms-2 me-auto d-flex">
                                    <span className="align-self-center">{resource.name}</span>
                                </div>
                                <Button className="btn-primary" onClick={() => {
                                    setEditData(resource)
                                    setUploadView(true)
                                    setDataType("resource")
                                }
                                }>Bearbeiten</Button>
                            </li>
                        ))}
                    </div>
                ) : (
                    <section className="mt-5 d-flex justify-content-center border-bottom">
                        <p>
                            <i>Es sind keine Ressourcen gespeichert.</i>
                        </p>
                    </section>
                )}
            </section>
        </section>
    )
}

BaseDataRoute.loader = async function ({
    params: { windowId },
}: LoaderFunctionArgs) {
    const actions = await getBaseData(`data/action/all`)
    const locations = await getBaseData(`data/location/all`)
    const resources = await getBaseData(`data/resource/all`)

    return { actions, locations, resources, windowId }
}

BaseDataRoute.action = async function ({ request }: ActionFunctionArgs<Request>) {
    const formData = await request.formData()
    // Get the CSRF token from the formData
    const csrf = formData.get("csrf_token") ?? "nischt"
    console.log("hi" + formData.get("file"))
    const dataId = formData.get("id")
    let data = {}
    if (formData.get("formType") === "delete") {
        console.log(formData.get("media_refs_del"))
        data = {
            id: dataId,
            media_refs_del: JSON.parse(formData.get("media_refs_del") as string),
        };
    } else {

        // indicates if the backend should handle a raw txt
        const type = formData.get("type")
        const url = `media/${type}`
        const media = await tryFetchJson<Media>(url, {
            body: formData,
            method: "POST",
        })

        data = {
            id: dataId,
            media_refs_add: [media]
        }
    }

    // Perform the PATCH request with the serialized JSON data
    const response = await fetch(api + `data/${formData.get("dataType")}`, {
        method: "PATCH",
        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": csrf.toString(), // Include CSRF token
        },
        body: JSON.stringify(data),
    });

    // Instead of redirecting, reload the current page
    if (response.ok) {
        const url = `/data/${formData.get("dataType")}-${formData.get("id")}`
        console.log(url)
        window.location.href = url;
    } else {
        console.error('Failed to update scenario:', response.text());
    }
    return ""
}