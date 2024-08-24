import { ActionFunctionArgs, LoaderFunctionArgs, useLoaderData } from "react-router";
import { tryFetchJson } from "../api";
import { BaseDataStripped, Scenario } from "../types";
import { CsrfForm } from "../components/CsrfForm";
import { useContext, useState } from "react";
import ScenarioData from "../components/scenario-data";

export function ScenarioEditor() {
    const scenario = useLoaderData() as Scenario
    const [editView, setEditView] = useState(false)

    const [scenarioName, setScenarioName] = useState<string>(scenario.name)
    const [addPatientList, setAddPatientList] = useState<BaseDataStripped[]>([])
    const [deletePatientList, setDeletePatientList] = useState<BaseDataStripped[]>([])

    const [addVehicleList, setAddVehicleList] = useState<BaseDataStripped[]>([])
    const [deleteVehicleList, setDeleteVehicleList] = useState<BaseDataStripped[]>([])

    return (
        <section className="mt-5">
            <div id="headline">
                <h1 className="fs-2">Szenario Übersicht</h1>
            </div>
            <CsrfForm method="PATCH" className="">
                <section id="scenario-header" className="border-bottom border-2 border-dark mt-5 pb-5">
                    <div className="d-flex d-row">
                        <div className="d-flex ms-5 fs-5">
                            <label className="align-self-center">Name:</label>
                            <input type="text" className="form-control ms-5" value={`${scenarioName}`} disabled={editView ? false : true} onChange={(event) => setScenarioName(event.target.value)} />
                        </div>
                        <div className="ms-auto me-5">
                            {editView ? (
                                <button type="submit" className="btn btn-primary">Speichern</button>
                            ) : (
                                <button type="button" className="btn btn-primary" onClick={() => (setEditView(true))}>Bearbeiten</button>
                            )}
                        </div>
                    </div>
                </section>
                <section id="scenario-body" className="d-flex ms-5 mt-3">
                    <ScenarioData
                        data={scenario.patients}
                        className="flex-fill"
                        name="Patienten"
                        editView={editView}
                        addDataList={addPatientList}
                        deleteDataList={deletePatientList}
                        setAddDataList={setAddPatientList}
                        setDeleteDataList={setDeletePatientList} />

                    <ScenarioData
                        data={scenario.vehicles_quantity}
                        className="flex-fill ms-5"
                        name="Fahrzeuge"
                        editView={editView}
                        addDataList={addVehicleList}
                        deleteDataList={deleteVehicleList}
                        setAddDataList={setAddVehicleList}
                        setDeleteDataList={setDeleteVehicleList} />
                </section>
            </CsrfForm>
        </section>
    )
}

ScenarioEditor.loader = async function ({
    params: { scenarioId },
}: LoaderFunctionArgs) {
    return await tryFetchJson<Scenario>(`/scenario?scenario_id=${scenarioId}`)
}

ScenarioEditor.action = async function ({ request, params: { scenarioId } }: ActionFunctionArgs<Request>) {
    const formData = await request.formData()
    //TODO
}