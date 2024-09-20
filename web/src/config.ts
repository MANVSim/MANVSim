export const config = {
  pollingRate: 5000, // Frequency with which updates are requested from the server
  csrfPollingRate: 60000, // Time the sever waits before polling new csrf token.
  serverURLProd: "https://batailley.informatik.uni-kiel.de:5002/api", // PROD URL to direct player qr-codes
  serverURLDev: "https://localhost:5002/api" // PROD URL to direct player qr-codes
}
