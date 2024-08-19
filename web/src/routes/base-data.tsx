import { useLoaderData } from "react-router"
import { getBaseData } from "../api/base-data"
import { ActionData, BaseDataStripped } from "../types"

type BaseData = {
    actions: Array<BaseDataStripped>
    locations: Array<BaseDataStripped>
    resources: Array<BaseDataStripped>
}

export function BaseDataRoute() {
    const { actions, locations, resources } = useLoaderData() as BaseData


    return (
        <section>
            <section id="page-nav-section" className="d-flex justify-content-center mt-5">
                <div className="d-flex justify-content-center border-bottom border-dark border-2">
                    <div className="btn">
                        <span>Maßnahmen</span>
                    </div>
                    <div className="btn">
                        <span>Ressourcenverwahrungsobjekte</span>
                    </div>
                    <div className="btn">
                        <span>Ressourcen</span>
                    </div>
                </div>
            </section>
            <section id="base-data-list">
                {actions.length ? (
                    <div className="mt-2">

                    </div>
                ) : (
                    <div className="mt-2">
                        <p>
                            <i>Es sind keine Maßnahmen gespeichert.</i>
                        </p>
                    </div>
                )}
            </section>
        </section>
    )
}

BaseDataRoute.loader = async function () {
    const actions = await getBaseData(`data/action/all`)
    const locations = null //await getBaseData(`data/location/all`)
    const resources = await getBaseData(`data/resource/all`)

    return { actions, locations, resources }
}