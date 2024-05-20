import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/api": {
        // TODO: change this if you need a different port
        target: "http://localhost:5000",
        changeOrigin: true,
      },
    },
  },
});
