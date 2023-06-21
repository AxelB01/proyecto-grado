import { useContext, useEffect } from 'react'
import { axiosPrivate } from '../api/axios'
import AuthContext from '../context/AuthContext'
import useRefreshToken from './useRefreshToken'

const useAxiosPrivate = () => {
	const { token } = useContext(AuthContext)
	const refresh = useRefreshToken()

	useEffect(() => {
		const requestIntercepted = axiosPrivate.interceptors.request.use(
			config => {
				if (!config.headers.Authorization) {
					config.headers.Authorization = `Bearer ${token}`
				}
				return config
			},
			error => Promise.reject(error)
		)

		const responseIntercepted = axiosPrivate.interceptors.response.use(
			response => response,
			async error => {
				const prevRequest = error?.config
				if (
					(error?.response?.status === 401 ||
						error?.response?.status === 403) &&
					!prevRequest?.sent
				) {
					prevRequest.sent = true
					const newAcessToken = await refresh()
					prevRequest.headers.Authorization = `Bearer ${newAcessToken}`
					return axiosPrivate(prevRequest)
				}
				return Promise.reject(error)
			}
		)

		return () => {
			axiosPrivate.interceptors.request.eject(requestIntercepted)
			axiosPrivate.interceptors.response.eject(responseIntercepted)
		}
	}, [token, refresh])

	return axiosPrivate
}

export default useAxiosPrivate
