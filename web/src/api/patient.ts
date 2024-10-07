import { PatientResponse, isPatientRepsonse } from "../types"
import { tryFetchJson } from "./utils"

const patientApi = "data/patient/"

export async function getPatients(): Promise<PatientResponse[]> {
  const patients = await tryFetchJson<PatientResponse[]>(patientApi + "all")
  if (Array.isArray(patients) && patients.every(isPatientRepsonse)) {
    return patients
  }
  throw Error(`Could not load patients!`)
}

export async function getPatient(id: string): Promise<PatientResponse> {
  const patient = await tryFetchJson<PatientResponse>(patientApi + `${id}`)
  if (isPatientRepsonse(patient)) {
    return patient
  }
  throw Error(`Could not load patient with id: ${id}`)
}
