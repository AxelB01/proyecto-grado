import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const ESTADOS_DOCUMENTOS_URL = '/api/data/getEstadosDocumentos'

const useDocumentStates = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getDocumentStates = async () => {
			try {
				const response = await axiosPrivate.get(ESTADOS_DOCUMENTOS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getDocumentStates()
	}, [axiosPrivate])

	return data
}

export default useDocumentStates
