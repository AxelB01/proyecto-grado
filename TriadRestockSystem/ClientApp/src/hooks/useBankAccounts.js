import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const GET_BANK_ACCOUNTS_LIST = '/api/data/getCuentasBancos'

const useBankAccounts = () => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getBankAccounts = async () => {
			try {
				const response = await axiosPrivate.get(GET_BANK_ACCOUNTS_LIST)
				const data = response?.data
				setData(data)
			} catch (error) {
				console.log(error)
			}
		}

		getBankAccounts()
	}, [axiosPrivate])

	return data
}

export default useBankAccounts
