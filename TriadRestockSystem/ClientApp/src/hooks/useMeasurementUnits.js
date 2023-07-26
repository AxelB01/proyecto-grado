import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const UNIDADES_MEDIDAS_URL = '/api/data/getUnidadesMedidas'

const useMeasurementUnits = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getMeasurementUnits = async () => {
			try {
				const response = await axiosPrivate.get(UNIDADES_MEDIDAS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getMeasurementUnits()
	}, [axiosPrivate])

	return data
}

export default useMeasurementUnits
