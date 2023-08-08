import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const TIPOS_CUENTAS_URL = '/api/data/getTiposBancosCuentas'

const useBankAccountsTypes = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getBankAccountsTypes = async () => {
			try {
				const response = await axiosPrivate.get(TIPOS_CUENTAS_URL)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getBankAccountsTypes()
	}, [axiosPrivate])

	return data
}

export default useBankAccountsTypes
