import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const CENTROS_COSTOS_URL = '/api/data/getCentrosCostos'

const useCostCenters = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getCostCenters = async () => {
			try {
				const response = await axiosPrivate.get(CENTROS_COSTOS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getCostCenters()
	}, [axiosPrivate])

	return data
}

export default useCostCenters
