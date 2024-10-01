import { Navigate, Outlet, useNavigate } from "react-router"

// LinkContainer currently has a bug generating a deprecation warning in the
// console
// https://github.com/react-bootstrap/react-router-bootstrap/issues/317
import { LinkContainer } from "react-router-bootstrap"
import { Container, Nav, NavDropdown, Navbar } from "react-bootstrap"
import { ReactElement } from "react"
import { NavLink } from "../components/NavLink"
import { isLoggedIn, logout } from "../services/auth"
import { getStorageItem } from "../services/storage"

export function Root(): ReactElement {
  const navigate = useNavigate()

  if (!isLoggedIn()) {
    return <Navigate replace to="/login" />
  }

  function logoutCallback() {
    logout()
    navigate("login")
  }

  return (
    <>
      <Navbar expand="lg" className="bg-body-tertiary">
        <Container>
          <LinkContainer to="/">
            <Navbar.Brand>MANVSim</Navbar.Brand>
          </LinkContainer>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <NavLink to="/executions" name="Ausführungen" />
              <NavLink to="/patient" name="Patienten" />
              <NavLink to="/data/all" name="Stammdaten" />
              <NavDropdown title="Benutzer">
                <NavDropdown.Header>
                  {getStorageItem("user")}
                </NavDropdown.Header>
                <NavDropdown.Item onClick={logoutCallback}>
                  Logout
                </NavDropdown.Item>
              </NavDropdown>
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>
      <Container>
        <Outlet />
      </Container>
    </>
  )
}
