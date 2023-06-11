import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import createNotification from '../functions/notification'
import { sleep } from '../functions/sleep'
import { isStringEmpty } from '../functions/validation'
import Loader from './Loader'

const Home = () => {
	const { username, password, roles, token } = useContext(AuthContext)
	const { handleLayout } = useContext(LayoutContext)
	const navigate = useNavigate()
	const [loaded, setLoaded] = useState(true)

	useEffect(() => {
		document.title = 'Home'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (
			isStringEmpty(username) ||
			isStringEmpty(password) ||
			isStringEmpty(token) ||
			roles === undefined ||
			roles == null
		) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			setLoaded(false)
			createNotification(
				'success',
				'Credenciales validades',
				`Te damos la bienvenida ${username}`
			)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return loaded ? (
		<Loader />
	) : (
		<>
			<h2>Home</h2>
		</>
	)
}

export default Home
