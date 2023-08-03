import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const TIPOS_PROVEEDORES_URL = '/api/data/getTipoProveedor'

const useSuppliersTypes = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getItemsTypes = async () => {
			try {
				const response = await axiosPrivate.get(TIPOS_PROVEEDORES_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getItemsTypes()
	}, [axiosPrivate])

	return data
}

export default useSuppliersTypes
