import { Button, Col, Drawer, Form, Input, Row, Select, Space } from 'antd'
import { useContext, useEffect } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createItemsModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_ITEMS_URL = '/api/articulos/guardarArticulo'

const ItemsForm = ({
	title,
	open,
	onClose,
	unidadMedidaItems,
	tipoArticuloItems,
	familiaItems,
	initialValues,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const handleCloseForm = () => {
		form.resetFields()
		onClose()
	}

	useEffect(() => {
		form.resetFields()

		if (initialValues.IdArticulo !== 0) {
			const {
				IdArticulo,
				IdUnidadMedida,
				Codigo,
				Nombre,
				Descripcion,
				IdFamilia,
				IdTipoArticulo
			} = initialValues
			form.setFieldsValue({
				id: IdArticulo,
				unidadMedida: IdUnidadMedida,
				codigo: Codigo,
				nombre: Nombre,
				descripcion: Descripcion,
				familia: IdFamilia,
				tipoArticulo: IdTipoArticulo
			})
		}
	}, [form, initialValues])

	const saveItem = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ITEMS_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Artículo guardado')
				handleCloseForm()
			}
		} catch (error) {
			openMessage('error', 'Ha ocurrido un error')
			handleCloseForm()
			console.log(error)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createItemsModel()
		model.IdArticulo = values.id
		model.IdUnidadMedida = values.unidadMedida
		model.Codigo = values.codigo
		model.Nombre = values.nombre
		model.Descripcion = values.descripcion
		model.IdFamilia = values.familia
		model.IdTipoArticulo = values.tipoArticulo

		saveItem(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	return (
		<>
			<Drawer
				title={title}
				width={500}
				onClose={handleCloseForm}
				open={open}
				bodyStyle={{
					paddingBotton: 80
				}}
				extra={
					<Space>
						<Button onClick={handleCloseForm}>Cerrar</Button>
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
					<Form.Item name='id' style={{ display: 'none' }}>
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
								name='unidadMedida'
								label='Unidad de Medida'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar una unidad de medida'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={unidadMedidaItems.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='codigo'
								label='Codigo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo'
									}
								]}
							>
								<Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar un codigo'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='descripcion'
								label='Descripcion'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una descripcion'
									}
								]}
							>
								{/* <Input
									style={{ width: '100%' }}
									autoComplete='off'
									placeholder='Ingresar una descripcion'
								/> */}
								<Input.TextArea
									placeholder='Ingresar una descripción'
									rows={3}
									showCount
									maxLength={500}
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='familia'
								label='Familia'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar una familia'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={familiaItems.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='tipoArticulo'
								label='Tipo de articulo'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tipo de articulo'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={tipoArticuloItems.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Drawer>
		</>
	)
}

export default ItemsForm
