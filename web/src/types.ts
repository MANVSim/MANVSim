import { z } from "zod"
import { Dispatch, SetStateAction } from "react"

/**
 * Higher order function that returns a function which checks if a given object
 * is of the required type.
 *
 * @template T - The interface that the object should match
 * @param {ReturnType<typeof z.object>} zobj - zod object that contains the attributes
 * @returns {(x: unknown) => x is T} Function that checks the type of a passed object
 */
function isTypeFactory<T>(
  zobj: ReturnType<typeof z.object>,
): (x: unknown) => x is T {
  return (x: unknown): x is T => {
    const parsed = zobj.safeParse(x)
    if (!parsed.success) {
      console.error(`Invalid object: ${parsed.error.issues}`)
    }
    return parsed.success
  }
}

// CsrfToken
const csrfToken = z.object({
  csrf_token: z.string(),
})

export type CsrfToken = z.infer<typeof csrfToken>

/**
 * Checks if a variable matches the CsrfToken interface
 *
 * @param {unknown} x - Variable to check
 * @returns {obj is CsrfToken} true when variable is a CSRF token
 */
export const isCsrfToken = isTypeFactory<CsrfToken>(csrfToken)

// StartResponse
const startResponse = z.object({
  id: z.number(),
})

export type StartResponse = z.infer<typeof startResponse>

/**
 * Checks if a variable matches the StartResponse interface
 *
 * @param {unknown} x - Variable to check
 * @returns {obj is StartResponse} true when variable is a response from the start API call
 */
export const isStartResponse = isTypeFactory<StartResponse>(startResponse)

// LoginResponse
const loginResponse = z.object({
  token: z.string(),
})

export type LoginResponse = z.infer<typeof loginResponse>

// AuthValue
export type Nullable<T> = T | null
export type NullableString = Nullable<string>
export type SetAuthTokenType = Dispatch<SetStateAction<NullableString>>

export interface AuthValue {
  authToken: NullableString
  setAuthToken: SetAuthTokenType
}

// Error Response
const errorResponse = z.object({
  error: z.string(),
})

export type ErrorResponse = z.infer<typeof errorResponse>

/**
 * Checks if a variable matches the ErrorResponse interface
 *
 * @param {unknown} x - Variable to check
 * @returns {x is ErrorResponse} true when variable is an ErrorResponse
 * @function
 */
export const isErrorResponse = isTypeFactory<ErrorResponse>(errorResponse)

/**
 * Checks if a variable matches the LoginResponse interface
 *
 * @param {unknown} x - Variable to check
 * @returns {obj is LoginResponse} true when variable is a response from the login API call
 */
export const isLoginResponse = isTypeFactory<LoginResponse>(loginResponse)

// MANVSim Data
const media = z.object({
  media_type: z.string(),
  title: z.string().or(z.null()),
  text: z.string().or(z.null()),
  media_reference: z.string().or(z.null()),
})

export type Media = z.infer<typeof media>

const baseDataStripped = z.object({
  id: z.number(),
  name: z.string(),
  quantity: z.number().optional(),
  travel_time: z.number().optional(),
  media_refs: z.string().optional(),
})

export type BaseDataStripped = z.infer<typeof baseDataStripped>

export type Role = z.infer<typeof baseDataStripped>

export type Location = z.infer<typeof baseDataStripped>

// Player
const player = z.object({
  tan: z.string(),
  name: z.string().or(z.null()),
  alerted: z.boolean(),
  logged_in: z.boolean(),
  role: baseDataStripped.or(z.null()),
  location: baseDataStripped.or(z.null()),
})

export type Player = z.infer<typeof player>

export const isPlayer = isTypeFactory<Player>(player)

// Template: defines an scenario mapped with focus on execution
const template = z.object({
  id: z.number(),
  name: z.string(),
  executions: z.array(
    z.object({
      id: z.number(),
      name: z.string(),
    }),
  ),
})

export type Template = z.infer<typeof template>

/**
 * Checks if a variable matches the Template interface
 *
 * @param {unknown} x - Variable to check
 * @returns {obj is Template} true when variable is a template
 */
export const isTemplate = isTypeFactory<Template>(template)

// type of Scenario as requested for the editor
const scenario = z.object({
  id: z.number(),
  name: z.string(),
  patients: z.array(baseDataStripped),
  vehicles: z.array(baseDataStripped),
})

export type Scenario = z.infer<typeof scenario>

export const ExecutionStatusEnum = z.enum([
  "RUNNING",
  "PENDING",
  "FINISHED",
  "UNKNOWN",
])

const notifications = z.object({
  text: z.string(),
  timestamp: z.string(),
})
export type Notifications = z.infer<typeof notifications>

export type ExecutionStatus = z.infer<typeof ExecutionStatusEnum>

const executionData = z.object({
  id: z.number(),
  name: z.string().or(z.null()),
  players: z.array(player),
  status: ExecutionStatusEnum,
  roles: z.array(baseDataStripped),
  locations: z.array(baseDataStripped),
  notifications: z.array(notifications),
  patients: z.array(baseDataStripped),
})

export type ExecutionData = z.infer<typeof executionData>

/**
 * Checks if a variable matches the ExecutionData interface
 *
 * @param {unknown} x - Variable to check
 * @returns {obj is ExecutionData} true when variable matches the ExecutionData interface
 */
export const isExecutionData = isTypeFactory<ExecutionData>(executionData)

const actionData = z.object({
  id: z.number(),
  name: z.string().or(z.null()),
  min_role: z.string().or(z.null()),
  duration_secs: z.number(),
  media_refs: z.array(media),
  results: z.array(z.string()),
  resources: z.array(baseDataStripped),
})

export type ActionData = z.infer<typeof actionData>

const patientResponse = z.object({
  id: z.number(),
  name: z.string(),
  activity_diagram: z.string().optional(),
})

export type PatientResponse = z.infer<typeof patientResponse>
export const isPatientRepsonse = isTypeFactory<PatientResponse>(patientResponse)

export const mediaTypes = z.enum(["IMAGE", "VIDEO", "TEXT", "AUDIO"])
export type MediaTypeEnum = z.infer<typeof mediaTypes>

const condition = z.object({
  media_type: mediaTypes,
  title: z.string().or(z.null()),
  text: z.string().or(z.null()),
  media_reference: z.string().or(z.null()),
})

export type Condition = z.infer<typeof condition>

const state = z.object({
  pause_time: z.number(),
  uuid: z.string(),
  start_time: z.number(),
  timelimit: z.number(),
  after_time_state_uuid: z.string(),
  treatments: z.record(z.string(), z.string()),
  conditions: z.record(z.string(), z.array(condition)),
})

export type State = z.infer<typeof state>

const activityDiagram = z.object({
  current: state,
  states: z.record(z.string(), state),
})

export type ActivityDiagram = z.infer<typeof activityDiagram>

const patient = patientResponse.extend({
  activity_diagram: activityDiagram,
  id: z.number(),
  name: z.string(),
})

export type Patient = z.infer<typeof patient>
export const isPatient = isTypeFactory<Patient>(patient)

const locationData = z.object({
  id: z.number(),
  name: z.string(),
  is_vehicle: z.boolean(),
  media_refs: z.array(media),
  child_locations: z.array(baseDataStripped),
  resources: z.array(baseDataStripped),
})

export type LocationData = z.infer<typeof locationData>

const resourceData = z.object({
  id: z.number(),
  name: z.string().or(z.null()),
  media_refs: z.array(media),
  consumable: z.boolean(),
})

export type ResourceData = z.infer<typeof resourceData>

const action = z.object({
  id: z.number(),
  name: z.string(),
})

export type Action = z.infer<typeof action>
export const isAction = isTypeFactory<Action>(action)
