import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ALMACENES_USUARIOS_URL = '/api/data/getEstadosAlmacenes'

const useWharehouseStates = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getWharehouseStates = async () => {
			try {
				const response = await axiosPrivate.get(ALMACENES_USUARIOS_URL)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getWharehouseStates()
	}, [axiosPrivate])

	return data
}

export default useWharehouseStates
