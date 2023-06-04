import { LockOutlined, UserOutlined } from '@ant-design/icons'
import { Button, Checkbox, Form, Input } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import axios from '../api/axios'
import AuthContext from '../context/AuthContext'
import createNotification from '../functions/notification'
import './LoginForm.css'

const USER_REGEX = /^[a-zA-Z][a-zA-Z ]{4,}$/
const LOGIN_URL = 'api/auth/login'

const LoginForm = () => {
	const { createAuth, destroyStoredAuth } = useContext(AuthContext)

	const [form] = Form.useForm()
	const [loading, setLoading] = useState(false)
	const userRef = useRef()

	const onFinish = ({ username, password, remember }) => {
		const model = CreateLoginModel()
		model.Username = username
		model.Password = password
		model.Remember = remember

		handleLogin(model)
	}

	const handleLogin = async model => {
		try {
			const response = await axios.post(LOGIN_URL, model, {
				headers: { 'Content-Type': 'application/json' }
			})
			const data = response?.data
			const { username, password, roles, token } = data
			if (model.Remember) {
				destroyStoredAuth()
			}
			createAuth(username, password, roles, token, model.Remember)
		} catch (error) {
			if (!error?.response) {
				console.log('No hubo respuesta del servidor')
			} else {
				const data = JSON.stringify(error.response?.data)
				console.log(data)
				if (error.response?.status === 400) {
					createNotification('error', 'Credenciales inválidas', data)
				}
			}
			setLoading(false)
		}
	}

	useEffect(() => {
		userRef.current.focus()
	}, [])

	return (
		<Form
			form={form}
			className='form-login'
			name='form_login'
			initialValues={{ remember: false }}
			onFinish={onFinish}
		>
			<Form.Item
				name='username'
				rules={[
					{
						required: true,
						message: 'Debe ingresar su nombre de usuario'
					},
					{
						validator: (_, value) => {
							if (USER_REGEX.test(value)) {
								return Promise.resolve()
							}
							return Promise.reject(
								new Error('El nombre de usuario ingresado no es válido')
							)
						}
					}
				]}
				hasFeedback
			>
				<Input
					ref={userRef}
					size='large'
					prefix={<UserOutlined />}
					placeholder='Usuario'
				/>
			</Form.Item>
			<Form.Item
				name='password'
				rules={[{ required: true, message: 'Debe ingresar una contraseña' }]}
				hasFeedback
			>
				<Input.Password
					size='large'
					prefix={<LockOutlined />}
					type='password'
					placeholder='Contraseña'
				/>
			</Form.Item>
			<Form.Item>
				<Form.Item
					className='check-remember'
					name='remember'
					valuePropName='checked'
					noStyle
				>
					<Checkbox>Recordar credenciales</Checkbox>
				</Form.Item>
				<a href='' className='forgot-login'>
					¿Olvidaste tu contraseña?
				</a>
			</Form.Item>
			<Form.Item>
				<Button
					className='btn-login'
					type='primary'
					size='large'
					htmlType='submit'
					onClick={() => setLoading(!loading)}
					loading={loading}
				>
					Ingresar
				</Button>
			</Form.Item>
		</Form>
	)
}

const CreateLoginModel = () => {
	return {
		Username: '',
		Password: '',
		Remember: false
	}
}

export default LoginForm
