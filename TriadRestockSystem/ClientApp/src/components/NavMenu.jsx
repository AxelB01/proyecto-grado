import { useState } from 'react'
import { Link } from 'react-router-dom'
import {
	Collapse,
	Navbar,
	NavbarBrand,
	NavbarToggler,
	NavItem,
	NavLink
} from 'reactstrap'
import '../styles/NavMenu.css'

const NavMenu = () => {
	const [collapsed, setCollapsed] = useState(false)

	return (
		<header>
			<Navbar
				className='navbar-expand-sm navbar-toggleable-sm ng-white border-bottom box-shadow mb-3'
				container
				light
			>
				<NavbarBrand tag={Link} to='/'>
					TriadRestockSystem
				</NavbarBrand>
				<NavbarToggler
					onClick={() => setCollapsed(!collapsed)}
					className='mr-2'
				/>
				<Collapse
					className='d-sm-inline-flex flex-sm-row-reverse'
					isOpen={collapsed}
					navbar
				>
					<ul className='navbar-nav flex-grow'>
						<NavItem>
							<NavLink tag={Link} className='text-dark' to='/'>
								Home
							</NavLink>
						</NavItem>
					</ul>
				</Collapse>
			</Navbar>
		</header>
	)
}

export default NavMenu
