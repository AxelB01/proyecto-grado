import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ALMACENES_SECCIONES_URL = '/api/data/getAlmacenSecciones'

const useWharehouseSections = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getWharehouseSections = async () => {
			try {
				const response = await axiosPrivate.get(ALMACENES_SECCIONES_URL)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getWharehouseSections()
	}, [axiosPrivate])

	return data
}

export default useWharehouseSections
