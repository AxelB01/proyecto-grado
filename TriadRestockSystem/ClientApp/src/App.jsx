import { useContext, useEffect, useRef } from 'react'
import { Route, Routes } from 'react-router-dom'
import AppRoutes from './AppRoutes'
import CustomLayout from './components/CustomLayout'
import AuthContext from './context/AuthContext'
import './custom.css'
import { isStringEmpty } from './functions/validation'

const App = () => {
	const { username, password, readStoredAuth, destroyStoredAuth } =
		useContext(AuthContext)
	const inactivityTimeout = useRef(null)

	useEffect(() => {
		document.title = 'App'
		readStoredAuth()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	useEffect(() => {
		const handleUserActivity = () => {
			clearTimeout(inactivityTimeout.current)

			inactivityTimeout.current = setTimeout(() => {
				if (!isStringEmpty(username) && !isStringEmpty(password)) {
					destroyStoredAuth()
					window.location.reload()
				}
			}, 900000)
		}

		window.addEventListener('mousemove', handleUserActivity)
		window.addEventListener('keydown', handleUserActivity)

		return () => {
			window.removeEventListener('mousemove', handleUserActivity)
			window.removeEventListener('keydown', handleUserActivity)
			clearTimeout(inactivityTimeout.current)
		}
	}, [username, password, destroyStoredAuth])

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
