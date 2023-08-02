import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const GET_ITEMS_LIST = '/api/data/getArticulosList'

const useItems = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getItems = async () => {
			try {
				const response = await axiosPrivate.get(GET_ITEMS_LIST)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getItems()
	}, [axiosPrivate])

	return data
}

export default useItems
