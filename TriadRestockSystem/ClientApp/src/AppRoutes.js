import CostsCenters from './components/CostsCenters'
import Families from './components/Families'
import Home from './components/Home'
import Login from './components/Login'
import Request from './components/Request'
import Requests from './components/Requests'
import Users from './components/Users'
import Items from './components/Items'
import Catalogs from './components/Catalogs'
import Suppliers from './components/Suppliers'

const AppRoutes = [
	{
		index: true,
		path: '/',
		element: <Home />
	},
	{
		index: false,
		path: '/login',
		element: <Login />
	},
	{
		index: false,
		path: '/users',
		element: <Users />
	},
	{
		index: false,
		path: '/families',
		element: <Families />
	},
	{
		index: false,
		path: '/requests',
		element: <Requests />
	},
	{
		index: false,
		path: '/request',
		element: <Request />
	},
	{
		index: false,
		path: '/families',
		element: <Families />
	},
	{
		index: false,
		path: '/items',
		element: <Items />
	},
	{
		index: false,
		path: '/catalogs',
		element: <Catalogs />
	},
	{
		index: false,
		path: '/costsCenters',
		element: <CostsCenters />
	},
	{
		index: false,
		path: '/suppliers',
		element: <Suppliers />
	}

]

export default AppRoutes
