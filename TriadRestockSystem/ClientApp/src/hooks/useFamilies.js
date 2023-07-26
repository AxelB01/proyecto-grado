import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const FAMILIAS_URL = '/api/data/getFamilias'

const useFamilies = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getFamilies = async () => {
			try {
				const response = await axiosPrivate.get(FAMILIAS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getFamilies()
	}, [axiosPrivate])

	return data
}

export default useFamilies
