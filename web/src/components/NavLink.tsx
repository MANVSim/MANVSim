import { Nav } from "react-bootstrap"
import { LinkContainer } from "react-router-bootstrap"

export type NavLinkProps = {
  to: string
  name: string
}

export function NavLink({ to, name }: NavLinkProps) {
  return (
    <LinkContainer to={to}>
      <Nav.Link>{name}</Nav.Link>
    </LinkContainer>
  )
}
