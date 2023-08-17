import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ARTICULOS_IMPUESTOS_URL = '/api/data/getImpuestosArticulos'

const useTaxes = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getTaxes = async () => {
			try {
				const response = await axiosPrivate.get(ARTICULOS_IMPUESTOS_URL)
				const items = response?.data
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getTaxes()
	}, [axiosPrivate])

	return data
}

export default useTaxes
