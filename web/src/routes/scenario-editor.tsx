import { ActionFunctionArgs, LoaderFunctionArgs, useLoaderData, } from "react-router";
import {api, tryFetchJson} from "../api";
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
                        </div>
                        <div className="ms-auto me-5">
                            <button type="submit" className={`btn btn-primary ${editView ? "" : "d-none"} me-3`} onClick={() => { setEditView(false) }}>Speichern</button>
                            {editView ? (
                                <button type="button" className="btn btn-danger" onClick={resetCachedData}>Abbrechen</button>
                            ) : (
                                <button type="button" className="btn btn-primary" disabled={editView} onClick={() => (setEditView(true))}>Bearbeiten</button>
                            )}
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

    const scenario_id = formData.get("id")
    const data = {
        id: scenario_id,
        name: formData.get("name"),
        patients_add: JSON.parse(formData.get("patients_add") as string),
        patients_del: JSON.parse(formData.get("patients_del") as string),
        vehicles_add: JSON.parse(formData.get("vehicles_add") as string),
        vehicles_del: JSON.parse(formData.get("vehicles_del") as string)
    };

    // Get the CSRF token from the formData
    const csrf = formData.get("csrf_token") ?? "nischt"

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