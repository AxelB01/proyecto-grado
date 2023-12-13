import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../../context/LayoutContext'
import { createItemsTypeModel } from '../../functions/constructors'
import useAxiosPrivate from '../../hooks/usePrivateAxios'

const ITEMS_TYPE_SAVE = '/api/configuraciones/guardarTipoArticulos'

const ItemsTypeForm = ({
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nuevo tipo de articulos')

	useEffect(() => {
		const { Id, Nombre } = initialValues
		form.setFieldsValue({
			id: Id,
			nombre: Nombre
		})

		setTitle('Nuevo tipo de articulos')

		if (Id !== 0) {
			setTitle('Editar tipo de articulos')
		}
	}, [form, initialValues, open])

	const saveType = async model => {
		try {
			const response = await axiosPrivate.post(ITEMS_TYPE_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Tipo guardado')
				handleLoading(false)
				handleOpen(false)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createItemsTypeModel()
		model.Id = values.id
		model.Nombre = values.nombre
		saveType(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleOpen(false)
	}

	return (
		<>
			<Modal
				title={title}
				open={open}
				onOk={handleSubmit}
				onCancel={handleCancel}
				footer={[
					<Button key='back' onClick={handleCancel}>
						Cancelar
					</Button>,
					<Button
						key='submit'
						type='primary'
						loading={loading}
						onClick={handleSubmit}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_item_type'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
					{/* <Col span={24}>
							<Form.Item
								name='id'
								label='Codigo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo del tipo'
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar un nombre' />
							</Form.Item>
						</Col> */}
						<Col span={24}>
							<Form.Item
								name='nombre'
								label='Nombre'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre del tipo'
									}
								]}
								hasFeedback
							>
								<Input autoComplete='off' placeholder='Ingresar un nombre' />
							</Form.Item>
						</Col>
						
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default ItemsTypeForm
