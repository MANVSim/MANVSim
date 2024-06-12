import { useContext } from "react";
import { AuthContext } from "./auth";
import { CsrfContext } from "./csrf";

export function useAuth() {
  return useContext(AuthContext)
}

export function useCsrf() {
  return useContext(CsrfContext)
}
