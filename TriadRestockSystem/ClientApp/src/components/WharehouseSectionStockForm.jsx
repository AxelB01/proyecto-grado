import { Button, Col, Form, Input, InputNumber, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createWharehouseSectionStockModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const WHAREHOUSE_SECTION_STOCK_SAVE =
	'/api/almacenes/guardarAlmacenSeccionEstanteria'

const REGEX_INPUT_LENGTH_VALIDATION = /^.{1,50}$/

const WharehouseSectionStockForm = ({
	idSectionStock,
	initialValues,
	wharehouseStates,
	items,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()
	const values = Form.useWatch([], form)

	const [title, setTitle] = useState('Nueva estantería')

	useEffect(() => {
		form.resetFields()

		const { IdEstanteria, Codigo, IdArticulo, Maximo, Minimo } = initialValues

		let IdSeccion = idSectionStock

		if (idSectionStock === 0) {
			IdSeccion = initialValues.IdSeccion
		}

		form.setFieldsValue({
			idSeccion: IdSeccion,
			idEstanteria: IdEstanteria,
			codigo: Codigo,
			maximo: Maximo,
			minimo: Minimo
		})

		if (IdArticulo !== 0) {
			form.setFieldsValue({
				idArticulo: IdArticulo
			})
		}

		setTitle('Editar estantería')
		form.setFieldsValue({
			idEstado: initialValues.IdEstado
		})

		if (IdEstanteria === 0) {
			form.setFieldsValue({
				idEstado: 1
			})
			setTitle('Nueva estantería')
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues, idSectionStock])

	const saveSectionStock = async model => {
		try {
			const response = await axiosPrivate.post(
				WHAREHOUSE_SECTION_STOCK_SAVE,
				model
			)
			if (response?.status === 200) {
				openMessage('success', 'Estantería guardada')
				handleLoading(false)
				handleOpen(false)
			}
		} catch (error) {
			console.log(error)
			openMessage('error', 'Error procesando la solicitud...')
			handleLoading(false)
			handleOpen(false)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createWharehouseSectionStockModel()
		model.IdSeccion = values.idSeccion
		model.IdEstanteria = values.idEstanteria
		model.Codigo = values.codigo
		model.IdEstado = values.idEstado
		model.IdArticulo = values.idArticulo
		model.Maximo = values.maximo
		model.Minimo = values.minimo
		saveSectionStock(model)
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
					name='form_wharehouse_section'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='idSeccion'>
						<Input type='hidden' />
					</Form.Item>
					<Form.Item style={{ display: 'none' }} name='idEstanteria'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='codigo'
								label='Estantería'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre de la estantería'
									},
									{
										pattern: REGEX_INPUT_LENGTH_VALIDATION,
										message:
											'El nombre de la estantería debe tener menos de 50 caracteres'
									}
								]}
								hasFeedback
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar el nombre de la estantería'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='idEstado'
								label='Estado'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un estado para este estante'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={wharehouseStates?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='idArticulo'
								label='Artículo'
								rules={[
									{
										required: true,
										message:
											'Debe seleccionar el artículo destinado para esta estántería'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={items?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item name='minimo' label='Mínimo Requerido'>
								<InputNumber min={1} />
							</Form.Item>
						</Col>
						<Col span={12}>
							<Form.Item
								name='maximo'
								label='Capacidad'
								rules={[
									{
										validator: (_, value) => {
											if (value < values.minimo) {
												return Promise.reject(
													new Error(
														'La capacidad máxima del estante debe ser igual o mayor al mínimo requerido'
													)
												)
											}

											return Promise.resolve()
										}
									}
								]}
							>
								<InputNumber min={1} />
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default WharehouseSectionStockForm
