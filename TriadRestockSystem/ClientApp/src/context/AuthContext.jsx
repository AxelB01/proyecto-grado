import { createContext, useState } from 'react'
import { isStringEmpty } from '../functions/validation'

const AuthContext = createContext({})

export const AuthProvider = ({ children }) => {
	const {
		validLogin,
		username,
		password,
		roles,
		token,
		refreshtoken,
		readStoredAuth,
		createAuth,
		setNewToken,
		setNewRefreshToken,
		destroyAuth,
		destroyStoredAuth
	} = useAuth()

	return (
		<AuthContext.Provider
			value={{
				validLogin,
				username,
				password,
				roles,
				token,
				refreshtoken,
				readStoredAuth,
				createAuth,
				setNewToken,
				setNewRefreshToken,
				destroyAuth,
				destroyStoredAuth
			}}
		>
			<>{children}</>
		</AuthContext.Provider>
	)
}

const useAuth = () => {
	const [auth, setAuth] = useState({
		validLogin: false,
		username: '',
		password: '',
		roles: [],
		token: '',
		refreshtoken: ''
	})

	const createAuth = (
		validLogin,
		username,
		password,
		roles,
		token,
		refreshtoken,
		remember
	) => {
		setAuth({
			validLogin,
			username,
			password,
			roles,
			token,
			refreshtoken
		})

		const storedAuth = StoredAuth(
			validLogin,
			username,
			password,
			roles,
			refreshtoken
		)
		const jsonStoredAuth = JSON.stringify(storedAuth)

		sessionStorage.setItem('auth', jsonStoredAuth)

		if (remember) {
			localStorage.setItem('auth', jsonStoredAuth)
		}
	}

	const readStoredAuth = () => {
		let remember = true
		let storedAuth = localStorage.getItem('auth')
		if (isStringEmpty(storedAuth)) {
			remember = false
			storedAuth = sessionStorage.getItem('auth')
		}

		if (!isStringEmpty(storedAuth)) {
			const {
				storedLogin,
				storedUsername,
				storedPassword,
				storedRoles,
				storedRefreshToken
			} = JSON.parse(storedAuth)
			createAuth(
				storedLogin,
				storedUsername,
				storedPassword,
				storedRoles,
				'',
				storedRefreshToken,
				remember
			)
		}
	}

	const setNewToken = token => {
		setAuth({
			...auth,
			token
		})
	}
	const setNewRefreshToken = refreshtoken => {
		setAuth({
			...auth,
			refreshtoken
		})
	}

	const destroyAuth = () => {
		setAuth({
			validLogin: false,
			username: '',
			password: '',
			roles: [],
			token: '',
			refreshtoken: ''
		})
		destroyStoredAuth()
	}

	const destroyStoredAuth = () => {
		sessionStorage.removeItem('auth')
		localStorage.removeItem('auth')
	}

	return {
		...auth,
		readStoredAuth,
		createAuth,
		setNewToken,
		setNewRefreshToken,
		destroyAuth,
		destroyStoredAuth
	}
}

const StoredAuth = (validLogin, username, password, roles, refreshtoken) => {
	return {
		storedLogin: validLogin,
		storedUsername: username,
		storedPassword: password,
		storedRoles: roles,
		storedRefreshToken: refreshtoken
	}
}

export default AuthContext
