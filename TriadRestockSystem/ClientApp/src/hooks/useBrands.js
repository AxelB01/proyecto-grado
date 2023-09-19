import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ARTICULOS_MARCAS_URL = '/api/data/getMarcasArticulos'

const useBrands = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getBrands = async () => {
			try {
				const response = await axiosPrivate.get(ARTICULOS_MARCAS_URL)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getBrands()
	}, [axiosPrivate])

	return data
}

export default useBrands
