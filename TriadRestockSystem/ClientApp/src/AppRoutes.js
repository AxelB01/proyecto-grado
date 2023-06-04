import Home from './components/Home'
import Login from './components/Login'

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
	}
]

export default AppRoutes
