import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import Loader from './Loader'

const Home = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout } = useContext(LayoutContext)
	const navigate = useNavigate()
	const [loaded, setLoaded] = useState(true)

	useEffect(() => {
		document.title = 'Home'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (
			// isStringEmpty(username) ||
			// isStringEmpty(password) ||
			// isStringEmpty(token) ||
			// roles === undefined ||
			// roles == null
			!validLogin
		) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			setLoaded(false)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return loaded ? <Loader /> : <>Home</>
}

export default Home
