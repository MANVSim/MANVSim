import { BaseDataStripped } from "../types"
import { tryFetchJson } from "./utils"

export async function getBaseData(url:string): Promise<BaseDataStripped[]> {
 const result = tryFetchJson<BaseDataStripped[]>(url)
 return result   
}