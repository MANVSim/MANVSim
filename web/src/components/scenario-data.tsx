import { useState } from "react";
import { BaseDataStripped } from "../types";
import SearchableDropdown from "./searchbar";

import "./scenario-data.css"

interface ScenarioDataProps {
    data: BaseDataStripped[],
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
        quantity: null
    }
    const [editData, setEditData] = useState<BaseDataStripped>(emptyBaseData)
    const [editDataQuantity, setEditDataQuantity] = useState<number>(0)

    const [editRenameData, setRenameData] = useState<BaseDataStripped>(emptyBaseData)
    const [editRenameDataName, setRenameDataName] = useState<string>("")

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
                newDatas.push({ id: value.id, name: newName, quantity: null })
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

    const handleRenameItemInData = (value: BaseDataStripped) => {
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
            return [...updatedAddList, { id: data.id, name: newName, quantity: null }];
        });

        // filter newName and mark oldname for deletion as data type
        setDeleteDataList(prevDeleteDataList => {
            const updatedDeleteList = prevDeleteDataList.filter(item => item.name !== newName);
            return [...updatedDeleteList, data];
        });


        setRenameDataName("")
        setRenameDataView(false)
    }

    return (
        <div className={className}>
            <section id="data-quantity-editor" className={`d-flex p-3 border rounded bg-dark w-100 ${editViewData ? "" : "d-none"}`}>
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
            <section id="data-rename-editor" className={`d-flex p-3 border rounded bg-dark w-100 ${renameDataView ? "" : "d-none"}`}>
                <div className="d-flex me-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-person align-self-center text-white" viewBox="0 0 16 16">
                        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                    </svg>
                </div>
                <input className="form-control ms-auto" onChange={(e) => setRenameDataName(e.target.value)} />
                <button type="button" className="btn btn-primary ms-2" onClick={() => renameData(editRenameData, editRenameDataName)}>Speichern</button>
                <button type="button" className="btn btn-danger ms-2" onClick={() => setRenameDataView(false)}>X</button>
            </section>
            <div id="data-block" className={`${editViewData ? "mt-1 " : "mt-5"} border rounded p-3 pb-5 bg-light`}>
                <h2 className="fs-4">{name}</h2>
                <SearchableDropdown
                    data={data}
                    className={`ms-3 mt-3 border-bottom border-top border-2 border-dark pb-2 pt-2 ${editView ? "" : "d-none"}`}
                    onAddItem={handleAddItemToDatas}
                />
                <div id="data-items" className="m-3">
                    {addDataList.length ? (
                        <div id="new-Data-items">
                            {
                                addDataList.map((item) => (
                                    <div className="d-flex flex-row mt-2">
                                        <div className="d-flex me-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-person align-self-center" viewBox="0 0 16 16">
                                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                                            </svg>
                                        </div>
                                        <div className="d-flex me-3 fs-5 w-100">
                                            <div className="ms-2 align-self-center">{item.name}</div>
                                        </div>
                                        <div className="d-flex">
                                            <button id="edit-btn" type="button" className={`btn btn-outline-primary me-2 ${editView ? "" : "d-none"}`} onClick={() => handleRenameItemInData(item)}>
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
                                    <div className={`d-flex flex-row mt-2 ${deleteDataList.includes(item) ? "d-none" : ""}`}>
                                        <div className="d-flex me-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" className="bi bi-person align-self-center" viewBox="0 0 16 16">
                                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z" />
                                            </svg>
                                        </div>
                                        <div className="d-flex me-3 fs-5 w-100">
                                            <div className=" ms-2 align-self-center">{item.name}</div>
                                        </div>
                                        <div className="d-flex">
                                            <button id="edit-btn" type="button" className={`btn btn-outline-primary me-2 ${editView ? "" : "d-none"}`} onClick={() => handleRenameItemInData(item)}>
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
                        <div className="mt-5 d-flex justify-content-center border-bottom">
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