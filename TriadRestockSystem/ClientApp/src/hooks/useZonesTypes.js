import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const GET_ZONES_TYPES = '/api/data/getTiposZonas'

const useZonesTypes = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getTypesZones = async () => {
			try {
				const response = await axiosPrivate.get(GET_ZONES_TYPES)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getTypesZones()
	}, [axiosPrivate])

	return data
}

export default useZonesTypes
