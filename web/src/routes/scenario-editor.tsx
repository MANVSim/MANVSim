import { ActionFunctionArgs, LoaderFunctionArgs, redirect, useLoaderData, } from "react-router";
import { api, tryFetchJson } from "../api";
import { BaseDataStripped, Scenario } from "../types";
import { CsrfForm } from "../components/CsrfForm";
import { useState } from "react";
import ScenarioData from "../components/scenario-data";

type ScenarioLoaderType = {
    scenario: Scenario,
    all_vehicles: BaseDataStripped[],
    all_patients: BaseDataStripped[]
}

export function ScenarioEditor() {
    const { scenario, all_vehicles, all_patients } = useLoaderData() as ScenarioLoaderType
    const [editView, setEditView] = useState(false)
    const [deleteScenario, setDeleteScenario] = useState(false)

    const [scenarioName, setScenarioName] = useState<string>(scenario.name)
    const [addPatientList, setAddPatientList] = useState<BaseDataStripped[]>([])
    const [deletePatientList, setDeletePatientList] = useState<BaseDataStripped[]>([])

    const [addVehicleList, setAddVehicleList] = useState<BaseDataStripped[]>([])
    const [deleteVehicleList, setDeleteVehicleList] = useState<BaseDataStripped[]>([])

    const resetCachedData = () => {
        setEditView(false)
        setAddPatientList([])
        setAddVehicleList([])
        setDeletePatientList([])
        setDeleteVehicleList([])
    }

    return (
        <section className="mt-5">
            <div id="headline">
                <h1 className="fs-2">Szenario Übersicht</h1>
            </div>
            <CsrfForm method="PATCH" className="">
                <input name="id" value={scenario.id} type="hidden" />
                <section id="scenario-header" className="border-bottom border-2 border-dark mt-5 pb-5">
                    <div className="d-flex d-row">
                        <div className="d-flex ms-5 fs-5">
                            <label className="align-self-center">Name:</label>
                            <input type="text" className="form-control ms-5" name="name" value={`${scenarioName}`} disabled={!editView} onChange={(event) => setScenarioName(event.target.value)} />
                            {!editView && (
                                <input type="hidden" name="name" value={`${scenarioName}`} />
                            )}
                            <button type="submit" className={`btn btn-danger ${editView ? "d-none" : ""} ms-3`} onClick={() => { setDeleteScenario(true) }}>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" className="bi bi-trash3" viewBox="0 0 16 16">
                                    <path d="M6.5 1h3a.5.5 0 0 1 .5.5v1H6v-1a.5.5 0 0 1 .5-.5M11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3A1.5 1.5 0 0 0 5 1.5v1H1.5a.5.5 0 0 0 0 1h.538l.853 10.66A2 2 0 0 0 4.885 16h6.23a2 2 0 0 0 1.994-1.84l.853-10.66h.538a.5.5 0 0 0 0-1zm1.958 1-.846 10.58a1 1 0 0 1-.997.92h-6.23a1 1 0 0 1-.997-.92L3.042 3.5zm-7.487 1a.5.5 0 0 1 .528.47l.5 8.5a.5.5 0 0 1-.998.06L5 5.03a.5.5 0 0 1 .47-.53Zm5.058 0a.5.5 0 0 1 .47.53l-.5 8.5a.5.5 0 1 1-.998-.06l.5-8.5a.5.5 0 0 1 .528-.47M8 4.5a.5.5 0 0 1 .5.5v8.5a.5.5 0 0 1-1 0V5a.5.5 0 0 1 .5-.5" />
                                </svg>
                            </button>
                        </div>
                        <div className="ms-auto me-5">
                            <button type="submit" className={`btn btn-primary ${editView ? "" : "d-none"} me-3`} onClick={() => { setEditView(false) }}>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-floppy" viewBox="0 0 16 16">
                                    <path d="M11 2H9v3h2z" />
                                    <path d="M1.5 0h11.586a1.5 1.5 0 0 1 1.06.44l1.415 1.414A1.5 1.5 0 0 1 16 2.914V14.5a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 14.5v-13A1.5 1.5 0 0 1 1.5 0M1 1.5v13a.5.5 0 0 0 .5.5H2v-4.5A1.5 1.5 0 0 1 3.5 9h9a1.5 1.5 0 0 1 1.5 1.5V15h.5a.5.5 0 0 0 .5-.5V2.914a.5.5 0 0 0-.146-.353l-1.415-1.415A.5.5 0 0 0 13.086 1H13v4.5A1.5 1.5 0 0 1 11.5 7h-7A1.5 1.5 0 0 1 3 5.5V1H1.5a.5.5 0 0 0-.5.5m3 4a.5.5 0 0 0 .5.5h7a.5.5 0 0 0 .5-.5V1H4zM3 15h10v-4.5a.5.5 0 0 0-.5-.5h-9a.5.5 0 0 0-.5.5z" />
                                </svg>
                            </button>
                            {editView ? (
                                <button type="button" className="btn btn-danger" onClick={resetCachedData}>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" className="bi bi-x-lg" viewBox="0 0 16 16">
                                        <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z" />
                                    </svg>
                                </button>
                            ) : (
                                <button type="button" className="btn btn-primary" disabled={editView} onClick={() => (setEditView(true))}>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" className="bi bi-pencil-square" viewBox="0 0 16 16">
                                        <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z" />
                                        <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5z" />
                                    </svg>
                                </button>
                            )}
                            <input type="text" name="delete" value={`${deleteScenario}`} hidden readOnly />
                        </div>
                    </div>
                </section>
                <section id="scenario-body" className="d-flex mt-3">
                    <ScenarioData
                        data={scenario.patients}
                        searchBarData={all_patients}
                        className="flex-fill"
                        name="Patienten"
                        editView={editView}
                        addDataList={addPatientList}
                        deleteDataList={deletePatientList}
                        setAddDataList={setAddPatientList}
                        setDeleteDataList={setDeletePatientList} />

                    <ScenarioData
                        data={scenario.vehicles}
                        searchBarData={all_vehicles}
                        className="flex-fill"
                        name="Einsatzfahrzeuge" // this field is used for string matching in scenario-data.tsx
                        editView={editView}
                        addDataList={addVehicleList}
                        deleteDataList={deleteVehicleList}
                        setAddDataList={setAddVehicleList}
                        setDeleteDataList={setDeleteVehicleList} />
                </section>
                {/* Serialize lists into hidden inputs */}
                <input type="hidden" name="patients_add" value={JSON.stringify(addPatientList)} />
                <input type="hidden" name="patients_del" value={JSON.stringify(deletePatientList)} />
                <input type="hidden" name="vehicles_add" value={JSON.stringify(addVehicleList)} />
                <input type="hidden" name="vehicles_del" value={JSON.stringify(deleteVehicleList)} />
            </CsrfForm>
        </section>
    )
}

ScenarioEditor.loader = async function ({
    params: { scenarioId },
}: LoaderFunctionArgs) {
    const scenario = await tryFetchJson<Scenario>(`scenario?scenario_id=${scenarioId}`)
    const all_vehicles = await tryFetchJson<BaseDataStripped[]>(`data/location/all-vehicles`)
    const all_patients = await tryFetchJson<BaseDataStripped[]>(`data/patient/all`)
    return { scenario, all_vehicles, all_patients }
}

ScenarioEditor.action = async function ({ request }: ActionFunctionArgs<Request>) {
    const formData = await request.formData();
    // Get the CSRF token from the formData
    const csrf = formData.get("csrf_token") ?? "nischt"
    const scenario_id = formData.get("id")
    const deleteScenario = formData.get("delete")

    if (deleteScenario === "true") {
        // Perform the PATCH request with the serialized JSON data
        const response = await fetch(`${api}scenario/delete?scenario_id=${scenario_id}`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRFToken": csrf.toString(), // Include CSRF token
            }
        });
        if (response.ok) {
            return redirect("/executions")
        } else {
            // Optionally, log the response for debugging
            const responseText = await response.text();
            console.error('Failed to update scenario:', responseText);
            return ""
        }
    }
    const data = {
        id: scenario_id,
        name: formData.get("name"),
        patients_add: JSON.parse(formData.get("patients_add") as string),
        patients_del: JSON.parse(formData.get("patients_del") as string),
        vehicles_add: JSON.parse(formData.get("vehicles_add") as string),
        vehicles_del: JSON.parse(formData.get("vehicles_del") as string)
    };


    // Perform the PATCH request with the serialized JSON data
    const response = await fetch(api + `scenario`, {
        method: "PATCH",
        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": csrf.toString(), // Include CSRF token
        },
        body: JSON.stringify(data),
    });

    // Optionally, log the response for debugging
    const responseText = await response.text();
    console.log(responseText);

    // Instead of redirecting, reload the current page
    if (response.ok) {
        window.location.reload();
    } else {
        console.error('Failed to update scenario:', responseText);
    }
    return ""
};