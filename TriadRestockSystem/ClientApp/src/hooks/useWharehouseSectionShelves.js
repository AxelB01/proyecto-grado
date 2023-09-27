import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ALMACENES_SECCIONES_ESTANTERIAS_URL =
	'/api/data/getAlmacenSeccionesEstanterias'

const useWharehouseSectionShelves = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getWharehouseSectionShelves = async () => {
			try {
				const response = await axiosPrivate.get(
					ALMACENES_SECCIONES_ESTANTERIAS_URL
				)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getWharehouseSectionShelves()
	}, [axiosPrivate])

	return data
}

export default useWharehouseSectionShelves
