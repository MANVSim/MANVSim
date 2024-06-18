export function isLoggedIn() {
  return localStorage.getItem("token") !== null
}
