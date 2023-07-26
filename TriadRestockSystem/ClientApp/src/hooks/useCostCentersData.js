import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const CENTROS_COSTOS_URL = '/api/centrosCostos/getCostsCentersData'

const useCostCentersData = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getCostCenters = async () => {
			try {
				const response = await axiosPrivate.get(CENTROS_COSTOS_URL)
				setData(response?.data)
			} catch (error) {
				console.log(error)
			}
		}

		getCostCenters()
	}, [axiosPrivate])

	return data
}

export default useCostCentersData
