import {
  Patient,
  PatientResponse,
  isPatient,
  isPatientRepsonse,
} from "../types"
import { tryFetchApi, tryFetchJson } from "./utils"

const patientApi = "data/patient/"

export async function getPatients(): Promise<PatientResponse[]> {
  const patients = await tryFetchJson<PatientResponse[]>(patientApi + "all")
  if (Array.isArray(patients) && patients.every(isPatientRepsonse)) {
    return patients
  }
  throw Error(`Could not load patients!`)
}

export async function getPatient(id: string): Promise<Patient> {
  const patient = await tryFetchJson<Patient>(patientApi + `${id}`)
  if (isPatient(patient)) {
    return patient
  }
  throw Error(`Could not load patient with id: ${id}`)
}

export async function putPatient(id: string, patient: Patient) {
  tryFetchApi(patientApi + `${id}`, {
    method: "PUT",
    body: JSON.stringify(patient),
    headers: {
      "Content-Type": "application/json",
    },
  })
}
