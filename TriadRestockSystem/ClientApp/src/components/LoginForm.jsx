import { LockOutlined, UserOutlined } from '@ant-design/icons'
import { Button, Checkbox, Form, Input } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import axios from '../api/axios'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createLoginModel } from '../functions/constructors'
import { isStringEmpty } from '../functions/validation'
import '../styles/LoginForm.css'

const USER_REGEX = /^[a-zA-Z][a-zA-Z ]{4,}$/
const LOGIN_URL = 'api/auth/login'

const LoginForm = () => {
	const { createAuth, destroyStoredAuth } = useContext(AuthContext)
	const { handleLayoutLoading, openMessage } = useContext(LayoutContext)

	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const [disabled, setDisabled] = useState(true)
	const [loading, setLoading] = useState(false)
	const userRef = useRef()

	const onFinish = ({ username, password, remember }) => {
		const model = createLoginModel()
		model.Username = username
		model.Password = password
		model.Remember = remember

		handleLogin(model)
	}

	const onFinishFailed = () => {
		setLoading(!loading)
	}

	const handleLogin = async model => {
		try {
			const response = await axios.post(LOGIN_URL, model, {
				headers: { 'Content-Type': 'application/json' }
			})
			if (response?.status === 200) {
				console.log(response.data)
				handleLayoutLoading(true)
				const data = response?.data
				const {
					firstname,
					lastname,
					fullname,
					username,
					password,
					roles,
					token,
					refreshtoken
				} = data

				destroyStoredAuth()
				createAuth(
					true,
					firstname,
					lastname,
					fullname,
					username,
					password,
					roles,
					token,
					refreshtoken,
					model.Remember
				)
			}
		} catch (error) {
			if (!error?.response) {
				console.log('No hubo respuesta del servidor')
				openMessage('error', 'No hubo respuesta del servidor')
			} else {
				openMessage('error', 'Credenciales inválidas')
			}
			setLoading(false)
		}
	}

	useEffect(() => {
		userRef.current.focus()
	}, [])

	useEffect(() => {
		const username = values?.username ?? ''
		const password = values?.password
		setDisabled(!USER_REGEX.test(username) || isStringEmpty(password))
	}, [values])

	return (
		<Form
			form={form}
			className='form-login'
			name='form_login'
			initialValues={{ remember: false }}
			onFinish={onFinish}
			onFinishFailed={onFinishFailed}
		>
			<Form.Item
				name='username'
				rules={[
					{
						required: true,
						message: 'Debe ingresar su nombre de usuario',
						
					},
					{
						validator: (_, value) => {
							if (USER_REGEX.test(value) && value.length <= 50) {
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
				rules={[
					{ required: true, message: 'Debe ingresar una contraseña' },
					{
						validator: (_, value) => {
							if (value.length <= 100) {
								return Promise.resolve()
							}
							return Promise.reject(
								new Error('El texto ingresadp excede el límite permitido')
							)
						}
					}
				]}
				hasFeedback
			>
				<Input.Password
					size='large'
					prefix={<LockOutlined />}
					type='password'
					placeholder='Contraseña'
				/>
			</Form.Item>
			<Form.Item style={{ display: 'none' }}>
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
					disabled={disabled}
				>
					Ingresar
				</Button>
			</Form.Item>
		</Form>
	)
}

export default LoginForm
