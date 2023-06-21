import { useContext } from 'react'
import axios from '../api/axios'
import AuthContext from '../context/AuthContext'
import { createRefreshTokenModel } from '../functions/constructors'

const URL_REFRESH_TOKEN = 'api/auth/getNewAcessToken'

const useRefreshToken = () => {
	const { refreshtoken, setNewToken } = useContext(AuthContext)

	const refresh = async () => {
		const model = createRefreshTokenModel()
		model.RefreshToken = refreshtoken

		const response = await axios.post(URL_REFRESH_TOKEN, model, {
			headers: { 'Content-Type': 'application/json' }
		})
		if (response?.status === 200) {
			const newAccessToken = response.data
			setNewToken(newAccessToken)
			return newAccessToken
		}
	}
	return refresh
}
export default useRefreshToken
