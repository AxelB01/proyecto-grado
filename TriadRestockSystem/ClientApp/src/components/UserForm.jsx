import {
	Button,
	Col,
	Drawer,
	Form,
	Input,
	Row,
	Select,
	Space,
	Switch
} from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createUserModel } from '../functions/constructors'
import { isStringEmpty } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

// const INPUT_TEXT_REGEX = /[^a-zA-ZÀ-ÿ0-9\s]/
const INPUT_TEXT_NAME_REGEX = /^[A-Za-zñÑ\s]+$/
const INPUT_TEXT_USERNAME_REGEX = /^[A-Za-z]+$/
const SAVE_USER_URL = '/api/usuarios/guardarUsuario'

const UserForm = ({
	title,
	open,
	onClose,
	rolesItems,
	centrosCostosItems,
	getUsersData,
	initialValues,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)

	const [form] = Form.useForm()
	const values = Form.useWatch([], form)

	const [disabled, setDisabled] = useState(true)
	const [required, setRequired] = useState(false)

	const [switchValue, setSwitchValue] = useState(true)

	useEffect(() => {
		const {
			id,
			nombre,
			apellido,
			login,
			contrasena,
			estado,
			roles,
			centrosCostos
		} = initialValues

		setSwitchValue(estado === 1)

		form.setFieldsValue({
			id,
			nombre,
			apellido,
			login,
			contrasena,
			confirmarContrasena: contrasena,
			estado: estado === 1,
			roles,
			centrosCostos
		})
	}, [form, open, initialValues])

	useEffect(() => {
		const roles = values?.roles
		if (roles !== undefined) {
			const rolesPermissions = rolesItems.filter(r => roles.includes(r.key))
			let hasCostCenterPermissions = false
			rolesPermissions.forEach(r => {
				if (!hasCostCenterPermissions) {
					const permission = r.permissions.filter(
						p => p.module === 'Solicitudes de materiales'
					)[0]
					hasCostCenterPermissions =
						permission.view || permission.creation || permission.management
				}
			})
			setDisabled(!hasCostCenterPermissions)
			setRequired(hasCostCenterPermissions)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [values])

	const saveUser = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_USER_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Usuario guardado correctamente')
				onClose()
				getUsersData()
			}
		} catch (error) {
			console.log(error)
		}
	}

	const handleSwitchChange = checked => {
		setSwitchValue(checked)
		form.setFieldsValue({
			estado: checked
		})
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		console.log(values)
		const model = createUserModel()
		model.Id = values.id
		model.Name = values.nombre
		model.LastName = values.apellido
		model.Login = values.login
		model.Password = values.contrasena
		model.State = values.estado ? 1 : 2
		model.Roles = values.roles
		model.CostCenters = values.centrosCostos
		console.log(model)
		saveUser(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleOnClose = () => {
		form.resetFields()
		onClose()
	}

	return (
		<>
			<Drawer
				title={title}
				width={500}
				onClose={handleOnClose}
				open={open}
				bodyStyle={{
					paddingBotton: 80
				}}
				extra={
					<Space>
						<Button onClick={handleOnClose}>Cerrar</Button>
						<Button
							type='primary'
							onClick={handleSubmit}
							loading={loading}
							disabled={loading}
						>
							Guardar
						</Button>
					</Space>
				}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_user'
					layout='vertical'
					requiredMark
				>
					<Form.Item name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='nombre'
								label='Nombre'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un nombre'
									},
									{
										validator: (_, value) => {
											if (
												INPUT_TEXT_NAME_REGEX.test(value) &&
												value.length <= 100
											) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error('El nombre ingresado no es válido')
											)
										}
									}
								]}
								hasFeedback
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un nombre'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='apellido'
								label='Apellido'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un apellido'
									},
									{
										validator: (_, value) => {
											if (
												INPUT_TEXT_NAME_REGEX.test(value) &&
												value.length <= 100
											) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error('El apellido ingresado no es válido')
											)
										}
									}
								]}
								hasFeedback
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un apellido'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='login'
								label='Login'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un login'
									},
									{
										validator: (_, value) => {
											if (
												INPUT_TEXT_USERNAME_REGEX.test(value) &&
												value.length <= 50
											) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error('El login ingresado no es válido')
											)
										}
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un login'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='contrasena'
								label='Contraseña'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una contraseña'
									},
									{
										validator: (_, value) => {
											if (value.length <= 100) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error(
													'El texto ingresado excede el límite permitido'
												)
											)
										}
									}
								]}
								hasFeedback
							>
								<Input.Password
									type='password'
									placeholder='Ingresar contraseña'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								dependencies={['contrasena']}
								name='confirmarContrasena'
								label='Confirmar Contraseña'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una contraseña'
									},
									{
										validator: (_, value) => {
											const contrasena = values.contrasena ?? ''
											if (
												(!isStringEmpty(value) && contrasena !== value) ||
												value.length > 100
											) {
												return Promise.reject(
													new Error('Las contraseñas ingresadas no coinciden')
												)
											}
											return Promise.resolve()
										}
									}
								]}
								hasFeedback
							>
								<Input.Password
									type='password'
									placeholder='Ingresar contraseña de nuevo'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item name='estado' label='Estado'>
								<Switch
									checkedChildren='Activo'
									unCheckedChildren='Inactivo'
									onChange={handleSwitchChange}
									checked={switchValue}
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='roles'
								label='Roles'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar por lo menos un rol'
									}
								]}
								hasFeedback
							>
								<Select
									mode='multiple'
									allowClear
									placeholder='Seleccione uno o varios roles'
									optionFilterProp='label'
									options={rolesItems.map(rol => {
										return { value: rol.key, label: rol.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='centrosCostos'
								label='Centros de costos'
								rules={[
									{
										required,
										message: 'Debe seleccionar por lo menos un centro de costo'
									}
								]}
							>
								<Select
									mode='multiple'
									allowClear
									placeholder='Seleccione uno o varios centros de costos'
									options={centrosCostosItems.map(c => {
										return { value: c.key, label: c.text }
									})}
									disabled={disabled}
								></Select>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Drawer>
		</>
	)
}

export default UserForm
