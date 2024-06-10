import { useState } from "react";
import { AuthContext } from "./Auth";

export function useAuth() {
  return useState(AuthContext)
}
