import Button from "react-bootstrap/Button"
import ListGroup from "react-bootstrap/ListGroup"
import Stack from "react-bootstrap/Stack"
import { PatientResponse } from "../types"
import { ReactElement } from "react"
import { CsrfForm } from "./CsrfForm"
import { LinkContainer } from "react-router-bootstrap"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { faEdit, faTrash } from "@fortawesome/free-solid-svg-icons"

interface PatientEntryProps {
  patient: PatientResponse
}

export default function PatientEntry({
  patient,
}: PatientEntryProps): ReactElement {
  return (
    <ListGroup.Item>
      <Stack direction="horizontal" gap={1}>
        <div className="me-auto">{patient.name}</div>
        <LinkContainer to={`${patient.id}`}>
          <Button>
            <FontAwesomeIcon icon={faEdit} />
          </Button>
        </LinkContainer>
        <CsrfForm method="POST">
          <Button variant="danger" type="submit" name="id" value={patient.id}>
            <FontAwesomeIcon icon={faTrash} />
          </Button>
        </CsrfForm>
      </Stack>
    </ListGroup.Item>
  )
}
