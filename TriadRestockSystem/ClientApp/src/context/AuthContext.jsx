import { createContext, useState } from 'react'
import { isStringEmpty } from '../functions/validation'

const AuthContext = createContext({})

export const AuthProvider = ({ children }) => {
	const {
		username,
		password,
		roles,
		token,
		readStoredAuth,
		createAuth,
		setNewToken,
		destroyAuth,
		destroyStoredAuth
	} = useAuth()

	return (
		<AuthContext.Provider
			value={{
				username,
				password,
				roles,
				token,
				readStoredAuth,
				createAuth,
				setNewToken,
				destroyAuth,
				destroyStoredAuth
			}}
		>
			{children}
		</AuthContext.Provider>
	)
}

const useAuth = () => {
	const [auth, setAuth] = useState({
		username: '',
		password: '',
		roles: [],
		token: ''
	})

	const createAuth = (username, password, roles, token, remember) => {
		setAuth({
			username,
			password,
			roles,
			token
		})

		const storedAuth = StoredAuth(username, password, roles, token)
		const jsonStoredAuth = JSON.stringify(storedAuth)

		sessionStorage.setItem('auth', jsonStoredAuth)

		if (remember) {
			localStorage.setItem('auth', jsonStoredAuth)
		}
	}

	const readStoredAuth = () => {
		let storedAuth = localStorage.getItem('auth')
		if (isStringEmpty(storedAuth)) {
			storedAuth = sessionStorage.getItem('auth')
		}

		if (!isStringEmpty(storedAuth)) {
			const { storedUsername, storedPassword, storedRoles, storedToken } =
				JSON.parse(storedAuth)
			createAuth(storedUsername, storedPassword, storedRoles, storedToken, true)
		}
	}

	const setNewToken = token => {
		setAuth({
			...auth,
			token
		})
	}

	const destroyAuth = () => {
		setAuth({
			username: '',
			password: '',
			roles: [],
			token: ''
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
		destroyAuth,
		destroyStoredAuth
	}
}

const StoredAuth = (username, password, roles, token) => {
	return {
		storedUsername: username,
		storedPassword: password,
		storedRoles: roles,
		storedToken: token
	}
}

export default AuthContext
