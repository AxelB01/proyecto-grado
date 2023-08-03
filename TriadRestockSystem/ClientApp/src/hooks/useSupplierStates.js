import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ESTADOS_PROVEEDORES_URL = '/api/data/getEstadosProveedores'

const useSupplierStates = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getSupplierStates = async () => {
			try {
				const response = await axiosPrivate.get(ESTADOS_PROVEEDORES_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getSupplierStates()
	}, [axiosPrivate])

	return data
}

export default useSupplierStates
