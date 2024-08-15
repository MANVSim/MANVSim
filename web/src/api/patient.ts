import { Patient, isPatient } from "../types"
import { tryFetchJson } from "./utils"

export async function getPatients(): Promise<Patient[]> {
  const patients = await tryFetchJson<Patient[]>("patient")
  if (Array.isArray(patients) && patients.every(isPatient)) {
    return patients
  }
  throw Error(`Could not load patients!`)
}

export async function getPatient(id: string): Promise<Patient> {
  const patient = await tryFetchJson<Patient>(`patient/${id}`)
  if (isPatient(patient)) {
    return patient
  }
  throw Error(`Could not load patient with id: ${id}`)
}
