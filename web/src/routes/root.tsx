import { Navigate, Outlet, useNavigate } from "react-router"
// LinkContainer currently has a bug generating a deprecation warning in the
// console
// https://github.com/react-bootstrap/react-router-bootstrap/issues/317
import { LinkContainer } from "react-router-bootstrap"
import Container from "react-bootstrap/Container"
import Nav from "react-bootstrap/Nav"
import Navbar from "react-bootstrap/Navbar"
import { NavDropdown } from "react-bootstrap"
import { isLoggedIn } from "../utils"
import { ReactElement } from "react"

function NavLink({ to, name }: { to: string; name: string }): ReactElement {
  return (
    <LinkContainer to={to}>
      <Nav.Link>{name}</Nav.Link>
    </LinkContainer>
  )
}

export function Root(): ReactElement {
  const navigate = useNavigate()

  if (!isLoggedIn()) {
    return <Navigate replace to="/login" />
  }

  function logout() {
    localStorage.removeItem("token")
    localStorage.removeItem("user")
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
              <NavLink to="/" name="Home" />
              <NavLink to="/executions" name="Ausführungen" />
              <NavDropdown title="Benutzer">
                <NavDropdown.Header>
                  {localStorage.getItem("user")}
                </NavDropdown.Header>
                <NavDropdown.Item onClick={logout}>Logout</NavDropdown.Item>
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
