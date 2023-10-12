import Banks from './components/Banks'
import Catalogs from './components/Catalogs'
import Concepts from './components/Concepts'
import CostsCenters from './components/CostsCenters'
import Families from './components/Families'
import Home from './components/Home'
import Items from './components/Items'
import Login from './components/Login'
import Request from './components/Request'
import Requests from './components/Requests'
import Suppliers from './components/Suppliers'
import Units from './components/Units'
import Users from './components/Users'
import Wharehouse from './components/Wharehouse'
import Wharehouses from './components/Wharehouses'

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
	},
	{
		index: false,
		path: '/wharehouses',
		element: <Wharehouses />
	},
	{
		index: false,
		path: '/wharehouse',
		element: <Wharehouse />
	},
	{
		index: false,
		path: '/banks',
		element: <Banks />
	},
	{
		index: false,
		path: '/units',
		element: <Units />
	},
	{
		index: false,
		path: '/concepts',
		element: <Concepts />
	}
]

export default AppRoutes
