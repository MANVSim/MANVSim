import { useState } from "react";
import { BaseDataStripped } from "../types";
import SearchableDropdown from "./searchbar";

import "./scenario-data.css"

interface ScenarioDataProps {
    data: BaseDataStripped[],
    searchBarData: BaseDataStripped[],
    className: string,
    name: string,
    editView: boolean,
    addDataList: BaseDataStripped[],
    deleteDataList: BaseDataStripped[],
    setAddDataList: React.Dispatch<React.SetStateAction<BaseDataStripped[]>>,
    setDeleteDataList: React.Dispatch<React.SetStateAction<BaseDataStripped[]>>,
}

const ScenarioData: React.FC<ScenarioDataProps> = ({
    data,
    searchBarData,
    className = "",
    name = "",
    editView,
    addDataList,
    deleteDataList,
    setAddDataList,
    setDeleteDataList,

}) => {
    const [editViewData, setEditViewData] = useState(false)
    const [renameDataView, setRenameDataView] = useState(false)

    const [dataNames, setDataNames] = useState<string[]>(data.map(item => item.name))
    const [dataCounter, setDataCounter] = useState(dataNames.length)
    const emptyBaseData = {
        id: 0,
        name: "",
        travel_time: 0
    }
    const [editData, setEditData] = useState<BaseDataStripped>(emptyBaseData)
    const [editDataQuantity, setEditDataQuantity] = useState<number>(0)

    const [editRenameData, setRenameData] = useState<BaseDataStripped>(emptyBaseData)
    const [oldDataName, setOldDataName] = useState<string>("")
    const [editRenameDataName, setRenameDataName] = useState<string>("")
    const [editTravelTime, setEditTravelTime] = useState<number | undefined>(-1)

    const handleAddItemToDatas = (value: BaseDataStripped) => {
        setEditData(value)
        setEditViewData(true)
    }

    const addDataToList = (value: BaseDataStripped, quantity: number) => {
        const newDatas = []
        for (let index = 0; index < quantity; index++) {
            const newName: string = value.name + `-${index}`
            if (!(newName in dataNames)) {
                setDataNames([...dataNames, newName])
                newDatas.push({ id: value.id, name: newName, travel_time: 0 })
                setDataCounter(dataCounter + 1)
            }
        }
        setAddDataList([...addDataList, ...newDatas])
        setEditData(emptyBaseData)
        setEditViewData(false)
    }

    const handleDeleteItemFromDatas = (value: BaseDataStripped) => {
        if (addDataList.includes(value)) {
            setAddDataList(addDataList.filter(item => item !== value))
            setDeleteDataList([...deleteDataList, value])
        } else if (dataNames.includes(value.name)) {
            setDataNames(dataNames.filter(item => item !== value.name))
            setDeleteDataList([...deleteDataList, value])
        }
        setDataCounter(dataCounter - 1)
    }

    const handleUpdateData = (value: BaseDataStripped) => {
        setOldDataName(value.name)
        setEditTravelTime(value.travel_time)
        setRenameData(value)
        setRenameDataView(true)
    }
    const renameData = (data: BaseDataStripped, newName: string) => {
        // update blacklist of names
        setDataNames(prevDataNames => {
            const updatedNames = prevDataNames.filter(item => item !== data.name);
            return [...updatedNames, newName];
        });

        // filter old name and add newName as data type
        setAddDataList(prevAddDataList => {
            const updatedAddList = prevAddDataList.filter(item => item.name !== data.name);
            return [...updatedAddList, { id: data.id, name: newName, travel_time: data.travel_time }];
        });

        // filter newName and mark oldname for deletion as data type
        setDeleteDataList(prevDeleteDataList => {
            const updatedDeleteList = prevDeleteDataList.filter(item => item.name !== newName);
            return [...updatedDeleteList, data];
        });


        setRenameDataName("")
    }
    const setTravelTime = (editData: BaseDataStripped, newTravelTime: number) => {
        // filter old name and add newName as data type
        setAddDataList(prevAddDataList => {
            const updatedAddList = prevAddDataList.filter(item => item.name !== editData.name);
            return [...updatedAddList, { id: editData.id, name: editData.name, travel_time: newTravelTime }];
        });

        if (data.includes(editData)) {
            // filter newName and mark oldname for deletion as data type
            setDeleteDataList(prevDeleteDataList => {
                if (!prevDeleteDataList.includes(editData)) {
                    return [...prevDeleteDataList, editData];
                }
                return prevDeleteDataList;
            });
        }
        setEditTravelTime(-1)
    }

    const updateData = (data: BaseDataStripped, newTravelTime: number | undefined, newName: string) => {
        if (newTravelTime !== undefined && data.travel_time !== newTravelTime && newTravelTime >= 0) {
            setTravelTime(data, newTravelTime)
        }
        if (data.name !== newName && newName.length > 0) {
            renameData(data, newName)
        }
        setRenameDataView(false)
        setOldDataName("")
    }

    return (
        <div className={className}>
            <section id="data-quantity-editor" className={`d-flex p-3 border rounded bg-dark ${editViewData ? "" : "d-none"}`}>
                <div className="d-flex me-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-person align-self-center text-white" viewBox="0 0 16 16">
                        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                    </svg>
                </div>
                <div className="align-self-center text-white">{editData.name}</div>
                <input type="number" className="form-control ms-auto" value={editDataQuantity} onChange={(e) => setEditDataQuantity(+e.target.value)} />
                <button type="button" className="btn btn-primary ms-2" onClick={() => addDataToList(editData, editDataQuantity)}>Hinzufügen</button>
                <button type="button" className="btn btn-danger ms-2" onClick={() => setEditViewData(false)}>X</button>
            </section>
            <section id="data-update-editor" className={`p-3 border rounded bg-dark ${renameDataView ? "" : "d-none"}`}>
                <div className="d-flex w-100 mb-2">
                    <h1 className="text-white w-100 fs-5 align-self-center">Bearbeitet: {oldDataName}</h1>
                </div>
                <div className="d-flex w-100">
                    <div className="d-flex me-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-person align-self-center text-white" viewBox="0 0 16 16">
                            <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                        </svg>
                    </div>
                    <input id="name-input" className="form-control ms-auto" placeholder={oldDataName} value={editRenameDataName} onChange={(e) => setRenameDataName(e.target.value)} />
                    <input id="travel-input" type="number" className={`travel-display form-control ms-2 ${name === "Einsatzfahrzeuge" ? "" : "d-none"}`} placeholder="Anfahrtszeit" value={editTravelTime} onChange={(e) => setEditTravelTime(+e.target.value)} />
                    {name === "Einsatzfahrzeuge" ? (
                        <button type="button" className="btn btn-primary ms-2" onClick={() => updateData(editRenameData, editTravelTime, editRenameDataName)}>Speichern</button>
                    ) : (
                        <button type="button" className="btn btn-primary ms-2" onClick={() => updateData(editRenameData, -1, editRenameDataName)}>Speichern</button>
                    )}
                    <button type="button" className="btn btn-danger ms-2" onClick={() => setRenameDataView(false)}>X</button>
                </div>
            </section>
            <div id="data-block" className={`${editViewData || renameDataView ? "mt-1 " : "mt-5"} border rounded p-3 pb-5 bg-light`}>
                <h2 className="fs-4">{name}</h2>
                <SearchableDropdown
                    data={searchBarData}
                    className={`ms-3 mt-3 border-bottom border-top border-2 border-dark pb-2 pt-2 ${editView ? "" : "d-none"}`}
                    onAddItem={handleAddItemToDatas}
                />
                <div id="label-header" className="d-flex ms-3 mt-3">
                    <label className="name">Name</label>
                    <label className={`${name === "Einsatzfahrzeuge" ? "" : "d-none"} travel_time`}>Anfahrtszeit</label>
                </div>
                <div id="data-items" className="ms-3">
                    {addDataList.length ? (
                        <div id="new-Data-items">
                            {
                                addDataList.map((item) => (
                                    <div className="d-flex flex-row mt-2 me-2" key={item.name}>
                                        <div className="d-flex me-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-database-add align-self-center" viewBox="0 0 16 16">
                                                <path d="M12.5 16a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7m.5-5v1h1a.5.5 0 0 1 0 1h-1v1a.5.5 0 0 1-1 0v-1h-1a.5.5 0 0 1 0-1h1v-1a.5.5 0 0 1 1 0" />
                                                <path d="M12.096 6.223A5 5 0 0 0 13 5.698V7c0 .289-.213.654-.753 1.007a4.5 4.5 0 0 1 1.753.25V4c0-1.007-.875-1.755-1.904-2.223C11.022 1.289 9.573 1 8 1s-3.022.289-4.096.777C2.875 2.245 2 2.993 2 4v9c0 1.007.875 1.755 1.904 2.223C4.978 15.71 6.427 16 8 16c.536 0 1.058-.034 1.555-.097a4.5 4.5 0 0 1-.813-.927Q8.378 15 8 15c-1.464 0-2.766-.27-3.682-.687C3.356 13.875 3 13.373 3 13v-1.302c.271.202.58.378.904.525C4.978 12.71 6.427 13 8 13h.027a4.6 4.6 0 0 1 0-1H8c-1.464 0-2.766-.27-3.682-.687C3.356 10.875 3 10.373 3 10V8.698c.271.202.58.378.904.525C4.978 9.71 6.427 10 8 10q.393 0 .774-.024a4.5 4.5 0 0 1 1.102-1.132C9.298 8.944 8.666 9 8 9c-1.464 0-2.766-.27-3.682-.687C3.356 7.875 3 7.373 3 7V5.698c.271.202.58.378.904.525C4.978 6.711 6.427 7 8 7s3.022-.289 4.096-.777M3 4c0-.374.356-.875 1.318-1.313C5.234 2.271 6.536 2 8 2s2.766.27 3.682.687C12.644 3.125 13 3.627 13 4c0 .374-.356.875-1.318 1.313C10.766 5.729 9.464 6 8 6s-2.766-.27-3.682-.687C3.356 4.875 3 4.373 3 4" />
                                            </svg>
                                        </div>
                                        <div className="d-flex me-3 fs-5 w-100">
                                            <div className="ms-2 align-self-center">{item.name}</div>
                                        </div>
                                        <div className={`travel-display d-flex me-3 fs-5 ${name === "Einsatzfahrzeuge" ? "" : "d-none"}`}>
                                            <div className="ms-2 align-self-center">{item.travel_time}s</div>
                                        </div>
                                        <div className="d-flex">
                                            <button id="edit-btn" type="button" className={`btn btn-outline-primary me-2 ${editView ? "" : "d-none"}`} onClick={() => handleUpdateData(item)}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-pen" viewBox="0 0 16 16">
                                                    <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001m-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708z" />
                                                </svg>
                                            </button>
                                        </div>
                                        <div>
                                            <button id="add-btn" type="button" disabled={editView ? false : true} className="btn btn-outline-danger" onClick={() => handleDeleteItemFromDatas(item)}>-</button>
                                        </div>
                                    </div>
                                ))
                            }
                        </div>
                    ) : (<div></div>)}
                    {data.length && dataCounter > 0 ? (
                        <div id="Data-items">
                            {
                                data.map((item) => (
                                    <div className={`d-flex flex-row mt-2 me-2 ${deleteDataList.includes(item) ? "d-none" : ""}`} key={item.name}>
                                        <div className="d-flex me-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-database align-self-center" viewBox="0 0 16 16">
                                                <path d="M4.318 2.687C5.234 2.271 6.536 2 8 2s2.766.27 3.682.687C12.644 3.125 13 3.627 13 4c0 .374-.356.875-1.318 1.313C10.766 5.729 9.464 6 8 6s-2.766-.27-3.682-.687C3.356 4.875 3 4.373 3 4c0-.374.356-.875 1.318-1.313M13 5.698V7c0 .374-.356.875-1.318 1.313C10.766 8.729 9.464 9 8 9s-2.766-.27-3.682-.687C3.356 7.875 3 7.373 3 7V5.698c.271.202.58.378.904.525C4.978 6.711 6.427 7 8 7s3.022-.289 4.096-.777A5 5 0 0 0 13 5.698M14 4c0-1.007-.875-1.755-1.904-2.223C11.022 1.289 9.573 1 8 1s-3.022.289-4.096.777C2.875 2.245 2 2.993 2 4v9c0 1.007.875 1.755 1.904 2.223C4.978 15.71 6.427 16 8 16s3.022-.289 4.096-.777C13.125 14.755 14 14.007 14 13zm-1 4.698V10c0 .374-.356.875-1.318 1.313C10.766 11.729 9.464 12 8 12s-2.766-.27-3.682-.687C3.356 10.875 3 10.373 3 10V8.698c.271.202.58.378.904.525C4.978 9.71 6.427 10 8 10s3.022-.289 4.096-.777A5 5 0 0 0 13 8.698m0 3V13c0 .374-.356.875-1.318 1.313C10.766 14.729 9.464 15 8 15s-2.766-.27-3.682-.687C3.356 13.875 3 13.373 3 13v-1.302c.271.202.58.378.904.525C4.978 12.71 6.427 13 8 13s3.022-.289 4.096-.777c.324-.147.633-.323.904-.525" />
                                            </svg>
                                        </div>
                                        <div className="d-flex me-3 fs-5 w-100">
                                            <div className=" ms-2 align-self-center">{item.name}</div>
                                        </div>
                                        <div className={`travel-display d-flex me-3 fs-5 ${name === "Einsatzfahrzeuge" ? "" : "d-none"}`}>
                                            <div className="ms-2 align-self-center">{item.travel_time}s</div>
                                        </div>
                                        <div className="d-flex">
                                            <button id="edit-btn" type="button" disabled={editView ? false : true} className={`btn btn-outline-primary me-2`} onClick={() => handleUpdateData(item)}>
                                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-pen" viewBox="0 0 16 16">
                                                    <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001m-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708z" />
                                                </svg>
                                            </button>
                                        </div>
                                        <div>
                                            <button id="add-btn" type="button" disabled={editView ? false : true} className="btn btn-outline-danger" onClick={() => handleDeleteItemFromDatas(item)}>-</button>
                                        </div>
                                    </div>
                                ))
                            }
                        </div>
                    ) : (
                        <div className={`mt-5 d-flex justify-content-center ${addDataList.length > 0 ? "d-none" : ""}`}>
                            <p>
                                <i>Es sind keine Daten gespeichert.</i>
                            </p>
                        </div>
                    )}
                </div>
            </div>
        </div>

    );
};

export default ScenarioData;