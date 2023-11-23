import { useEffect, useState } from 'react'
import useAxiosPrivate from './usePrivateAxios'

const useDataList = url => {
	const [data, setData] = useState([])
	const axiosPrivate = useAxiosPrivate()

	useEffect(() => {
		const getData = async () => {
			try {
				const response = await axiosPrivate.get(url)
				const items = response?.data.items
				setData(items)
			} catch (error) {
				console.log(error)
			}
		}

		getData()
	}, [axiosPrivate, url])

	return data
}

export default useDataList
