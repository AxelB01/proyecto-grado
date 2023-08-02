import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const PAISES_URL = '/api/data/getPaises'

const useCountries = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getCountries = async () => {
			try {
				const response = await axiosPrivate.get(PAISES_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getCountries()
	}, [axiosPrivate])

	return data
}

export default useCountries
