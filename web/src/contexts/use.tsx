import { useState } from "react";
import { AuthContext } from "./AuthContext";

export function useAuth() {
  return useState(AuthContext)
}
