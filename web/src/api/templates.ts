import { Template, isTemplate } from "../types"
import { tryFetchJson } from "./utils"

export async function getTemplates(): Promise<Template[]> {
  const templates = await tryFetchJson<Template[]>("templates")
  if (Array.isArray(templates) && templates.every(isTemplate)) {
    return templates
  }
  throw Error(`Could not load templates!`)
}
