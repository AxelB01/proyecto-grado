import { Button, Col, Form, Input, Modal, Row } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createCatalogModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const CATALOGS_SAVE = '/api/catalogos/guardarCatalogo'

const CatalogsForm = ({
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nuevo catalogo de articulos')

	useEffect(() => {
		const { Id, Nombre } = initialValues
		form.setFieldsValue({
			id: Id,
			nombre: Nombre
		})

		setTitle('Nuevo catalogo de articulos')

		if (Id !== 0) {
			setTitle('Editar  catalogo de articulos')
		}
	}, [form, initialValues, open])

	const saveCatalog = async model => {
		// console.log(model)
		// handleLoading(false)
		// handleOpen(false)
		try {
			const response = await axiosPrivate.post(CATALOGS_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Catalogo guardado')
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
		const model = createCatalogModel()
		model.Id = values.id
		model.Nombre = values.nombre
		saveCatalog(model)
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
					name='form_catalogs'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
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
										message: 'Debe ingresar el nombre del catalogo'
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

export default CatalogsForm
