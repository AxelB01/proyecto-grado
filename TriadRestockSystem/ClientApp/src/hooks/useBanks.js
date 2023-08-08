import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const GET_BANKS_LIST = '/api/data/getBancos'

const useBanks = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getBanks = async () => {
			try {
				const response = await axiosPrivate.get(GET_BANKS_LIST)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getBanks()
	}, [axiosPrivate])

	return data
}

export default useBanks
