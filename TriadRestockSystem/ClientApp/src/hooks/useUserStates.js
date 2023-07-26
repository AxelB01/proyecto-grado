import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ESTADOS_USUARIOS_URL = '/api/data/getEstadosUsuarios'

const useUserStates = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getUserStates = async () => {
			try {
				const response = await axiosPrivate.get(ESTADOS_USUARIOS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getUserStates()
	}, [axiosPrivate])

	return data
}

export default useUserStates
