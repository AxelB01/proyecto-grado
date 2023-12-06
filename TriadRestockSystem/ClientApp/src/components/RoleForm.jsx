import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createModelRole } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const textAreaLimit = 250

const SAVE_ROLE = '/api/configuraciones/saveRole'

const RoleForm = ({ open, toggle, initialValues }) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const [title, setTitle] = useState('Nuevo rol')
	const [loading, setLoading] = useState(false)

	const [form] = Form.useForm()

	const cancel = () => {
		toggle()
		setTimeout(() => {
			setLoading(false)
			form.resetFields()
		}, 100)
	}

	const saveRole = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ROLE, model)
			if (response?.status === 200) {
				openMessage('success', 'Rol guardado correctamente')
			}
		} catch (error) {
			console.log(error)
			openMessage('error', 'Ha ocurrido un error inesperado')
		} finally {
			cancel()
		}
	}

	const handleSave = () => {
		form.submit()
	}

	const onFinish = values => {
		setLoading(true)
		const model = createModelRole()
		model.IdRole = values.id
		model.Role = values.role
		model.Description = values.description
		saveRole(model)
	}

	const onFinishFailed = values => {
		setLoading(false)
		console.log(values)
	}

	useEffect(() => {
		if (
			initialValues.Id !== undefined &&
			initialValues.Id !== null &&
			initialValues.Id !== 0
		) {
			setTitle('Editar rol')
			form.setFieldsValue({
				id: initialValues.Id,
				role: initialValues.Nombre,
				description: initialValues.Descripcion
			})
		} else {
			setTitle('Nuevo rol')
		}
	}, [initialValues, form])

	return (
		<>
			<Modal
				width={600}
				title={title}
				open={open}
				onCancel={cancel}
				footer={[
					<Button key='btn-cancel' onClick={cancel}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						onClick={handleSave}
						loading={loading}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					name='form_role'
					layout='vertical'
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					requiredMark={false}
				>
					<Form.Item name='id' style={{ display: 'none' }}>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='role'
								label='Rol'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre del rol'
									},
									{
										validator: (_, value) => {
											if (value.length <= 50) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error(
													'El nombre no puede superar los 50 caracteres'
												)
											)
										}
									}
								]}
							>
								<Input />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='description'
								label='Descripción'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una descripción'
									},
									{
										validator: (_, value) => {
											if (value.length <= textAreaLimit) {
												return Promise.resolve()
											}
											return Promise.reject(
												new Error(
													'El texto no puede superar los 250 caracteres'
												)
											)
										}
									}
								]}
							>
								<Input.TextArea rows={3} maxLength={textAreaLimit} showCount />
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default RoleForm
