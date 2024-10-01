import { useState } from "react"
import { Player } from "../types"
import { Button, Card } from "react-bootstrap"
import QRCode from "react-qr-code"

import "./TanCard.css"
import { config } from "../config"

export type TanCardProps = {
  player: Player
}

export function TanCard({ player }: TanCardProps) {
  const [toggle, setToggle] = useState(true)

  return (
    <Card className="w-100">
      <Button
        className={`btn-light btn-sm ${toggle ? "" : "d-none"}`}
        onClick={() => setToggle(!toggle)}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          fill="currentColor"
          className="bi bi-caret-down-fill"
          viewBox="0 0 16 16"
        >
          <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z" />
        </svg>
      </Button>
      <Button
        className={`btn-light btn-sm ${toggle ? "d-none" : ""}`}
        onClick={() => setToggle(!toggle)}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          fill="currentColor"
          className="bi bi-caret-up-fill"
          viewBox="0 0 16 16"
        >
          <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z" />
        </svg>
      </Button>
      <QRCode
        value={`${config.serverURLProd};${player.tan}`}
        className={`text-center align-self-center p-3 w-100 ${toggle ? "d-none" : ""}`}
      />
      <Card.Body>
        <Card.Title className={`text-center ${toggle ? "d-none" : ""}`}>
          {player.tan}
        </Card.Title>
        <div>Rolle: {player.role?.name ?? "Unbekannt"}</div>
        <div>Ort: {player.location?.name ?? "Unbekannt"}</div>
      </Card.Body>
    </Card>
  )
}
