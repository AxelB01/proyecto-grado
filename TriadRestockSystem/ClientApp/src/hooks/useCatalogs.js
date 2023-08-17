import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const GET_CATALOGS_LIST = '/api/data/getCatalogos'

const useCatalogs = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getCatalogs = async () => {
			try {
				const response = await axiosPrivate.get(GET_CATALOGS_LIST)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getCatalogs()
	}, [axiosPrivate])

	return data
}

export default useCatalogs
