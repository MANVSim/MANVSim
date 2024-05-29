import { Outlet } from "react-router";
import { Link } from "react-router-dom";

export default function Root() {
  return (
    <>
      <h1>MANVSim - Simulation eines Massenanfalls von Verletzten</h1>
      <div>
        <ul>
          <li><Link to={"/scenario"}>Scenario</Link></li>
        </ul>
      </div>
      <div>
        <Outlet />
      </div>
    </>
  )
}
