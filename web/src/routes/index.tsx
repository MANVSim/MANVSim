import { ReactElement } from "react";
import MANV from "../assets/MANV.png"
import "../index.css"
export default function Index(): ReactElement {
  return (
    <div id="main-page-container" className="d-flex flex-column align-items-center w-100">
      <div id="logo-container" className="d-flex" >
        <img className="" src={MANV} alt="" />
      </div>
      <div id="logo-subtitle" className="mt-auto d-flex justify-content-center w-100 mt-3">
        <div className="">
          <p>Eine OpenSource Anwendung der Christian-Albrechts Universität Kiel </p>
        </div>
      </div>
    </div>
  )
}
