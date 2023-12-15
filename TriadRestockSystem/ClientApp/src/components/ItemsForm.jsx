import { Button, Checkbox, Col, Form, Input, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createItemsModel } from '../functions/constructors'
import {
	isNotConvertibleToNumber,
	stringContainsNoLetters
} from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const REGEX_ONLY_NUMBERS = /^[0-9.,]+$/

const SAVE_ITEMS_URL = '/api/articulos/guardarArticulo'

const ItemsForm = ({
	title,
	open,
	onClose,
	unidadMedidaItems,
	tipoArticuloItems,
	familiaItems,
	marcas,
	initialValues,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [checkboxValue, setCheckboxValue] = useState(false)

	const handleCheckboxChange = e => {
		setCheckboxValue(e.target.checked)
	}

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
				IdTipoArticulo,
				IdMarca,
				ConsumoGeneral,
				Precio
			} = initialValues
			form.setFieldsValue({
				id: IdArticulo,
				unidadMedida: IdUnidadMedida,
				codigo: Codigo,
				nombre: Nombre,
				descripcion: Descripcion,
				familia: IdFamilia,
				tipoArticulo: IdTipoArticulo,
				marca: IdMarca,
				precio: Precio,
				consumoGeneral: ConsumoGeneral
			})

			setCheckboxValue(ConsumoGeneral)
		}
	}, [form, initialValues])

	const saveItem = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ITEMS_URL, model)
			if (response?.status === 200) {
				openMessage('success', 'Artículo guardado')
			}
		} catch (error) {
			openMessage('error', 'Ha ocurrido un error')
			console.log(error)
		} finally {
			handleCloseForm()
		}
	}

	const handleSubmit = () => {
		form.submit()
	}

	const onFinish = values => {
		handleLoading(true)

		const model = createItemsModel()
		model.IdArticulo = values.id
		model.IdUnidadMedida = values.unidadMedida
		model.Codigo = values.codigo
		model.Nombre = values.nombre
		model.Descripcion = values.descripcion
		model.IdFamilia = values.familia
		model.IdTipoArticulo = values.tipoArticulo
		model.ConsumoGeneral = checkboxValue
		model.Precio = Number(values.precio)

		if (isNotConvertibleToNumber(values.marca)) {
			model.Marca = values.marca[0]
		} else {
			model.IdMarca = values.marca
		}

		saveItem(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	return (
		<>
			<Modal
				style={{
					top: 30
				}}
				width={800}
				title={title}
				open={open}
				onCancel={handleCloseForm}
				footer={[
					<Button key='btn-close' onClick={handleCloseForm}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						onClick={handleSubmit}
						loading={loading}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='item_form'
					layout='vertical'
					requiredMark={false}
				>
					<Form.Item name='id' style={{ display: 'none' }}>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={14}>
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
											if (stringContainsNoLetters(value)) {
												return Promise.reject(
													new Error('Debe ingresar un nombre válido')
												)
											}
											return Promise.resolve()
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
						<Col span={10}>
							<Form.Item
								name='marca'
								label='Marca'
								rules={[
									{
										required: false,
										message: 'Debe seleccionar una marca'
									},
									{
										validator: (_, value) => {
											if (value.length > 1) {
												return Promise.reject(
													new Error('Debe seleccionar una sola marca')
												)
											}
											return Promise.resolve()
										}
									}
								]}
							>
								<Select
									mode='tags'
									placeholder='Seleccionar'
									options={marcas?.map(m => {
										return { value: m.key, label: m.text }
									})}
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
									},
									{
										validator: (_, value) => {
											if (value.length > 500) {
												return Promise.reject(
													new Error('El texto excede el límite')
												)
											}
											return Promise.resolve()
										}
									}
								]}
								hasFeedback
							>
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
						<Col span={8}>
							<Form.Item
								name='codigo'
								label='Codigo'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un codigo'
									},
									{
										validator: (_, value) => {
											if (value.length > 10) {
												return Promise.reject(
													new Error('El texto excede el límite')
												)
											}
											return Promise.resolve()
										}
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
						<Col span={8}>
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
						<Col span={8}>
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
						<Col span={8}>
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
						<Col span={8}>
							<Form.Item
								name='consumoGeneral'
								style={{ marginTop: '1.75rem', marginLeft: '3rem' }}
							>
								<Checkbox
									checked={checkboxValue}
									onChange={handleCheckboxChange}
								>
									De consumo general
								</Checkbox>
							</Form.Item>
						</Col>
						<Col span={8}>
							<Form.Item
								name='precio'
								label='Precio'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un precio base para el artículo'
									},
									{
										validator: (_, value) => {
											if (
												!REGEX_ONLY_NUMBERS.test(value) &&
												value?.length > 0
											) {
												return Promise.reject(
													new Error('Debe ingresar un precio válido')
												)
											}
											return Promise.resolve()
										}
									}
								]}
							>
								<Input
									style={{ textAlign: 'end' }}
									autoComplete='off'
									placeholder='0.00'
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default ItemsForm
