import Home from './components/Home'
import Login from './components/Login'
import Users from './components/Users'

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
	}
]

export default AppRoutes
