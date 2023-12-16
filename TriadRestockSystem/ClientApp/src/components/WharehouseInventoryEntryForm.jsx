import {
	Button,
	Col,
	DatePicker,
	Form,
	Input,
	InputNumber,
	Modal,
	Row,
	Select,
	Switch
} from 'antd'
import locale from 'antd/es/date-picker/locale/es_ES'
import 'moment/locale/es-do'
import { useContext, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createInventoryEntryModel } from '../functions/constructors'
import {
	addThousandsSeparators,
	roundIfMoreThanTwoDecimalPlaces
} from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const INVENTORY_ENTRY = '/api/inventarios/entradaInventario'

// const REGEX_INPUT_LENGTH_VALIDATION = /^.{1,500}$/
// const REGEX_PRICE_FORMATTER = /\B(?=(\d{3})+(?!\d))/g
// const REGEX_PRICE_PARSER = /\$\s?|(,*)/g
const DEFAULT_DATE_FORMAT = 'DD/MM/YYYY'

const WharehouseInvetoryEntryForm = ({
	wharehouseSections,
	sectionShelves,
	registereditems,
	itemStates,
	brands,
	taxes,
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading,
	handleRefreshData
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()
	const values = Form.useWatch([], form)

	const [saving, setSavig] = useState(false)
	const [title] = useState('Entrada de inventario')

	// useEffect(() => {
	// 	form.resetFields()
	// 	// eslint-disable-next-line react-hooks/exhaustive-deps
	// }, [initialValues])

	const saveInventoryEntry = async model => {
		try {
			const response = await axiosPrivate.post(INVENTORY_ENTRY, model)
			if (response?.status === 200) {
				if (response.data.status === 'Ok') {
					openMessage('success', 'Inventario actualizado')
				} else {
					openMessage('warning', 'Este artículo ya existe')
				}

				form.setFieldsValue({
					numeroSerie: ''
				})
			}
		} catch (error) {
			// console.log(error)
			// openMessage('error', 'Error procesando la solicitud...')
			// handleOpen(false)
		} finally {
			if (!saving) {
				form.resetFields()
				handleOpen(false)
			}

			handleRefreshData()
			handleLoading(false)
		}
	}

	const handleSubmitContinue = () => {
		handleLoading(true)
		setSavig(true)
		setTimeout(() => {
			form.submit()
		}, 500)
	}

	const handleSubmitFinish = () => {
		handleLoading(true)
		setSavig(false)
		setTimeout(() => {
			form.submit()
		}, 500)
	}

	const onFinish = values => {
		const model = createInventoryEntryModel()
		model.FechaVencimiento = values.fechaVencimiento
		model.IdAlmacenSeccionEstanteria = values.idAlmacenSeccionEstanteria
		model.IdArticulo = values.idArticulo
		model.IdEstado = values.idEstado
		model.IdImpuesto = values.idImpuesto
		model.IdMarca = values.idMarca
		model.Modelo = values.modelo
		model.Notas = values.notas
		model.NumeroSerie = values.numeroSerie
		model.SubTotal = values.subTotal
		model.NumeroSerieManual = values.tipoNumeroSerie
		model.PrecioCompra = Number(values.precioCompra)

		saveInventoryEntry(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleLoading(false)
		form.resetFields()
		handleOpen(false)
	}

	const handlePrecioCompraBlur = () => {
		const formattedValue = addThousandsSeparators(
			roundIfMoreThanTwoDecimalPlaces(values.subTotal)
		)
		form.setFieldsValue({
			precioCompra: formattedValue
		})
	}

	return (
		<>
			<Modal
				style={{
					top: 5
				}}
				width={750}
				title={title}
				open={open}
				onOk={() => {}}
				onCancel={handleCancel}
				footer={[
					<Button key='back' onClick={handleCancel}>
						Cancelar
					</Button>,
					<Button
						key='continue'
						type='primary'
						loading={loading}
						onClick={handleSubmitContinue}
					>
						Guardar y continuar
					</Button>,
					<Button
						key='submit'
						type='primary'
						loading={loading}
						onClick={handleSubmitFinish}
					>
						Guardar y finalizar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_inventory_entry'
					layout='vertical'
					requiredMark={false}
				>
					{/* <Form.Item style={{ display: 'none' }} name='idSeccion'>
						<Input type='hidden' />
					</Form.Item>
					<Form.Item style={{ display: 'none' }} name='idEstanteria'>
						<Input type='hidden' />
					</Form.Item> */}
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item
								name='idAlmacenSeccion'
								label='Sección'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar la sección'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={wharehouseSections?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
						<Col span={12}>
							<Form.Item
								name='idArticulo'
								label='Artículo'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar el artículo'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={registereditems?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item
								name='idAlmacenSeccionEstanteria'
								label='Estantería'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar la estantería'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={sectionShelves?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
						{/* <Col span={6}>
							<Form.Item name='minimo' label='Mínimo Requerido'>
								<InputNumber style={{ width: '85%' }} disabled />
							</Form.Item>
						</Col>
						<Col span={6}>
							<Form.Item name='maximo' label='Capacidad Máxima'>
								<InputNumber style={{ width: '85%' }} disabled />
							</Form.Item>
						</Col> */}
					</Row>
					<Row gutter={16}>
						<Col span={8}>
							<Form.Item
								name='numeroSerie'
								label='Número de serie'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el número de serie del artículo'
									}
								]}
								hasFeedback
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar el número de serie'
								/>
							</Form.Item>
						</Col>
						<Col span={4}>
							<Form.Item
								name='tipoNumeroSerie'
								style={{ marginTop: '1.80rem', display: 'none' }}
							>
								<Switch
									checkedChildren='Manual'
									unCheckedChildren='Autogenerado'
									defaultChecked={false}
								/>
							</Form.Item>
						</Col>
						<Col span={6}>
							<Form.Item
								name='idEstado'
								label='Estado'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un estado para el artículo'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={itemStates?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
						<Col span={6}>
							<Form.Item name='fechaVencimiento' label='Fecha de vencimiento'>
								<DatePicker
									format={DEFAULT_DATE_FORMAT}
									allowClear
									locale={locale}
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item
								name='idMarca'
								label='Marca'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar la marca'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={brands?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
								></Select>
							</Form.Item>
						</Col>
						<Col span={12}>
							<Form.Item name='modelo' label='Modelo'>
								<Input
									autoComplete='off'
									placeholder='Ingresar el modelo del artículo'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={8}>
							<Form.Item
								name='subTotal'
								label='Sub Total'
								rules={[
									{
										required: true,
										message: 'Debe ingresar un precio para este artículo'
									}
								]}
							>
								<InputNumber
									addonBefore='RD$'
									defaultValue={0.0}
									style={{
										width: '100%',
										textAlign: 'right'
									}}
									onBlur={handlePrecioCompraBlur}
									onPressEnter={handlePrecioCompraBlur}
								/>
							</Form.Item>
						</Col>
						<Col span={8}>
							<Form.Item name='idImpuesto' label='Impuesto'>
								<Select
									placeholder='Seleccionar'
									options={taxes?.map(x => {
										return { value: x.key, label: x.text }
									})}
									showSearch
									allowClear
								></Select>
							</Form.Item>
						</Col>
						<Col span={8}>
							<Form.Item name='precioCompra' label='Total'>
								<Input prefix='RD$' style={{ textAlign: 'end' }} />
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='notas'
								label='Notas'
								rules={[
									{
										required: false
									}
								]}
							>
								<Input.TextArea rows={2} showCount maxLength={500} />
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default WharehouseInvetoryEntryForm
