import Banks from './components/Banks'
import Catalogs from './components/Catalogs'
import Concepts from './components/Concepts'
import CostsCenters from './components/CostsCenters'
import Families from './components/Families'
import Home from './components/Home'
import Items from './components/Items'
import Login from './components/Login'
import PurchaseOrder from './components/PurchaseOrder'
import PurchaseOrders from './components/PurchaseOrders'
import Request from './components/Request'
import RequestDispatch from './components/RequestDispatch'
import Requests from './components/Requests'
import Requisitions from './components/Requisitions'
import Roles from './components/Roles'
import Suppliers from './components/Suppliers'
import Units from './components/Units'
import Users from './components/Users'
import Wharehouse from './components/Wharehouse'
import WharehousePurchaseOrderRegistration from './components/WharehousePurchaseOrderRegistration'
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
	},
	{
		index: false,
		path: '/orders',
		element: <PurchaseOrders />
	},
	{
		index: false,
		path: '/requisitions',
		element: <Requisitions />
	},
	{
		index: false,
		path: '/roles',
		element: <Roles />
	},
	{
		index: false,
		path: '/purchaseOrder',
		element: <PurchaseOrder />
	},
	{
		index: false,
		path: '/wharehousePurchaseOrderRegistration',
		element: <WharehousePurchaseOrderRegistration />
	},
	{
		index: false,
		path: '/requestDispatch',
		element: <RequestDispatch />
	}
]

export default AppRoutes
