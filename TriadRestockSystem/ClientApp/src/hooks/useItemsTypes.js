import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const TIPOS_ARTICULOS_URL = '/api/data/getTiposArticulos'

const useItemsTypes = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getItemsTypes = async () => {
			try {
				const response = await axiosPrivate.get(TIPOS_ARTICULOS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getItemsTypes()
	}, [axiosPrivate])

	return data
}

export default useItemsTypes
