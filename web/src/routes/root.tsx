import { Navigate, Outlet } from "react-router";
import { LinkContainer } from 'react-router-bootstrap'
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';

function isLoggedIn() {
  return localStorage.getItem("token") !== null
}

function NavLink({ to, name }: { to: string, name: string }) {
  return <LinkContainer to={to}><Nav.Link>{name}</Nav.Link></LinkContainer>
}

export default function Root() {
  if (!isLoggedIn()) {
    return <Navigate replace to="/login" />
  }

  return (
    <>
      <Navbar expand="lg" className="bg-body-tertiary">
        <Container>
          <LinkContainer to="/"><Navbar.Brand>MANVSim</Navbar.Brand></LinkContainer>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <NavLink to="/" name="Home" />
              <NavLink to="/scenario" name="Szenario" />
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
