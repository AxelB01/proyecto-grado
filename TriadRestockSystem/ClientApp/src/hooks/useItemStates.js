import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ESTADOS_ARTICULOS_URL = '/api/data/getArticulosEstados'

const useItemStates = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getItemStates = async () => {
			try {
				const response = await axiosPrivate.get(ESTADOS_ARTICULOS_URL)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getItemStates()
	}, [axiosPrivate])

	return data
}

export default useItemStates
