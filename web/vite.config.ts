import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export default defineConfig({
  resolve: {
    alias: {
      path: "path-browserify",
    },
  },
  base: "/admin/",
  plugins: [react()],
})

