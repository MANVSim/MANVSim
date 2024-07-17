export function isLoggedIn(): boolean {
  return localStorage.getItem("token") !== null
}
