export function isLoggedIn() {
  return localStorage.getItem("token") !== null
}

export function isType<T extends object>(obj: unknown, ...requiredProps: (keyof T)[]): obj is T {
  return (
    obj !== null &&
    typeof obj === "object" &&
    requiredProps.every(prop => (obj as T)[prop] !== undefined)
  )
}
