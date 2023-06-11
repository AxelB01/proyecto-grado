import { useContext, useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'
import AppRoutes from './AppRoutes'
import CustomLayout from './components/CustomLayout'
import AuthContext from './context/AuthContext'
import './custom.css'

const App = () => {
	const { readStoredAuth, destroyStoredAuth } = useContext(AuthContext)

	useEffect(() => {
		document.title = 'App'
		destroyStoredAuth()
		readStoredAuth()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return (
		<CustomLayout>
			<Routes>
				{AppRoutes.map((route, index) => {
					const { element, ...rest } = route
					return <Route key={index} {...rest} element={element} />
				})}
			</Routes>
		</CustomLayout>
	)
}

export default App
