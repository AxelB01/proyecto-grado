import {
	CheckOutlined,
	ContainerOutlined,
	DeleteOutlined,
	EditOutlined,
	HomeOutlined,
	PlusOutlined,
	QuestionCircleOutlined,
	SaveOutlined
} from '@ant-design/icons'
import {
	Button,
	Col,
	DatePicker,
	Empty,
	Form,
	Input,
	InputNumber,
	Popconfirm,
	Row,
	Select,
	Table,
	Tag
} from 'antd'
import locale from 'antd/es/date-picker/locale/es_ES'
import moment from 'moment/moment'
import { useContext, useEffect, useRef, useState } from 'react'
import { useLocation } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createPurchaseOrderFormModel } from '../functions/constructors'
import {
	addThousandsSeparators,
	canBeConvertedToNumber
} from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import PurchaseOrderPaymentDetailModal from './PurchaseOrderPaymentDetailModal'

const GET_ORDEN_COMPRA = 'api/ordenescompra/getOrdenCompra'
const SAVE_PURCHASE_ORDER = 'api/ordenescompra/guardarOrdenCompra'
const APPROVE_PURCHASE_ORDER = 'api/ordenescompra/aprobarOrden'
const ARCHIVE_PURCHASE_ORDER = 'api/ordenescompra/archivarOrden'
const DISCARD_PURCHASE_ORDER = 'api/ordenescompra/descartarOrden'

const DATE_FORMAT = 'DD/MM/YYYY'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const PurchaseOrder = () => {
	const location = useLocation()
	const [customState, setCustomState] = useState({})
	const [dateValue, setDateValue] = useState(null)
	const [loaded, setLoaded] = useState(false)
	const [loading, setLoading] = useState(false)

	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		openMessage,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()

	const [wharehouses, setWharehouse] = useState([])
	const [paymentsTypes, setPaymentsTypes] = useState([])
	const [detailsTypes, setDetailsTypes] = useState([])
	const [taxes, setTaxes] = useState([])
	const [suppliers, setSuppliers] = useState([])
	const [items, setItems] = useState([])

	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const [saving, setSaving] = useState(false)

	const [title, setTitle] = useState('Nueva orden')
	const [enable, setEnable] = useState(true)

	const [tableKey] = useState(Date.now())
	const [tableStatus, setTableStatus] = useState(false)
	const tableRef = useRef()
	const [tableData, setTableData] = useState([])
	const [currentPage, setCurrentPage] = useState(1)
	const [count, setCount] = useState(0)

	const [detailsTableKey, setDetailsTableKey] = useState(Date.now())
	const [detailsTableStatus, setDetailsTableStatus] = useState(false)
	const detailsTableRef = useRef()
	const [detailsTableData, setDetailsTableData] = useState([])
	const [detailsTotal, setDetailsTotal] = useState(0)

	const [paymentDetailModalStatus, setPaymentDetailModalStatus] =
		useState(false)
	const [paymentDetailModalValues, setPaymentDetailModalValues] = useState({})

	const handlePaymentDetailModalStatus = () => {
		setPaymentDetailModalStatus(!paymentDetailModalStatus)
		if (!paymentDetailModalStatus) {
			setPaymentDetailModalValues({})
		}
	}

	const openPaymentDetailModal = () => {
		setPaymentDetailModalStatus(true)
	}

	const handleSavePaymentDetail = model => {
		const newData = [...detailsTableData]
		const target = newData.find(item => item.key === model.key)
		if (target) {
			target.tipo = model.tipo
			target.description = model.descripcion
			target.tasa = model.tasa
			target.valor = model.valor
		} else {
			newData.push(model)
		}

		setDetailsTableData(newData)
		setDetailsTableKey(Date.now())
	}

	const loadPaymentDetail = key => {
		const paymentDetail = detailsTableData.find(i => i.key === key)
		const model = {
			key: paymentDetail.key,
			descripcion: paymentDetail.descripcion,
			tipo: paymentDetail.tipo,
			tasa: paymentDetail.tasa,
			valor: paymentDetail.valor
		}

		setPaymentDetailModalValues(model)
	}

	const handleDeletePaymentDetail = key => {
		const newData = detailsTableData.filter(item => item.key !== key)
		setDetailsTableData(newData)
		setDetailsTableKey(Date.now())
	}

	const [baseTotal, setBaseTotal] = useState(0)
	const [taxesTotal, setTaxesTotal] = useState(0)
	const [finalTotal, setFinalTotal] = useState(0)

	useEffect(() => {
		const base = tableData.reduce((t, o) => t + o.precioBase * o.cantidad, 0)
		const taxes = tableData.reduce(
			(t, o) => t + o.precioBase * o.impuestoDecimal * o.cantidad,
			0
		)
		const total = tableData.reduce(
			(t, o) => t + o.precioBase * (1 + o.impuestoDecimal) * o.cantidad,
			0
		)

		setBaseTotal(base)
		setTaxesTotal(taxes)
		setFinalTotal(total)

		const detailsData = [...detailsTableData]
		let pagoBase = detailsData.find(i => i.key === 0)

		if (pagoBase) {
			pagoBase.valor = total
		} else {
			pagoBase = {
				key: 0,
				descripcion: 'Total Pedido',
				tipo: 1,
				tasa: 0,
				valor: total
			}
			detailsData.push(pagoBase)
		}

		setDetailsTableData(detailsData)
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [tableData])

	const detailsColumns = [
		{
			title: '',
			dataIndex: 'descripcion',
			key: 'descripcion',
			render: (text, record) => (
				<span style={{ fontWeight: record.tipo === 1 ? 'bold' : '' }}>
					{text}
				</span>
			)
		},
		{
			title: '',
			key: 'tipo',
			render: (_, record) => (
				<>
					<Tag
						color={
							record.tipo === 4
								? 'geekblue'
								: record.tipo === 2 || record.tipo === 3
								? 'volcano'
								: ''
						}
					>
						{detailsTypes.filter(d => d.key === record.tipo)[0]?.label}
					</Tag>
				</>
			)
		},
		{
			title: '',
			dataIndex: 'valor',
			key: 'valor',
			render: (number, record) => (
				<div style={{ textAlign: 'end' }}>
					<span style={{ fontWeight: record.tipo === 1 ? 'bold' : '' }}>
						{`RD$ ${addThousandsSeparators(number)}`}
					</span>
				</div>
			)
		},
		{
			title: '',
			key: 'action',
			render: (_, record) => (
				<div style={{ display: 'flex', justifyContent: 'center' }}>
					{record.tipo !== 1 ? (
						<>
							<Button
								type='text'
								icon={<EditOutlined />}
								onClick={() => loadPaymentDetail(record.key)}
							/>
							<Popconfirm
								title='¿Eliminar este registro?'
								cancelText='Cancelar'
								okText='Ok'
								onConfirm={() => handleDeletePaymentDetail(record.key)}
							>
								<Button type='text' icon={<DeleteOutlined />} />
							</Popconfirm>
						</>
					) : null}
				</div>
			)
		}
	]

	const columns = [
		{
			title: 'Artículo',
			dataIndex: 'articulo',
			key: 'articulo',
			render: (itemId, record) => (
				<Select
					style={{ width: 350 }}
					showSearch
					options={items
						.filter(i => !tableData.some(o => o.articulo === i.key))
						.map(i => {
							return {
								value: i.key,
								label: i.nombreCompleto
							}
						})}
					value={items.find(i => i.key === itemId)?.nombreCompleto ?? null}
					optionFilterProp='label'
					placeholder='Seleccionar un artículo...'
					onChange={value => handleChange(value, record.key, 'articulo')}
				/>
			)
		},
		{
			title: 'Cantidad',
			width: 80,
			dataIndex: 'cantidad',
			key: 'cantidad',
			render: (text, record) => (
				<span style={{ display: 'flex', justifyContent: 'center' }}>
					<InputNumber
						value={text}
						min={1}
						onChange={value => handleChange(value, record.key, 'cantidad')}
					/>
				</span>
			)
		},
		{
			title: 'Precio Base (RD$)',
			width: 150,
			dataIndex: 'precioBase',
			key: 'precioBase',
			render: (text, record) => (
				<Input
					value={text}
					onChange={e => {
						handleChange(e.target.value, record.key, 'precioBase')
					}}
				/>
			)
		},
		{
			title: 'Impuesto (RD$)',
			width: 150,
			key: 'impuesto',
			render: (_, record) => (
				<Input
					value={`${addThousandsSeparators(
						record.precioBase * record.impuestoDecimal
					)} (${record.impuesto})`}
					disabled
				/>
			)
		},
		{
			title: 'Total (RD$)',
			dataIndex: 'subtotal',
			key: 'subtotal',
			render: (_, record) => (
				<div style={{ display: 'flex', justifyContent: 'end' }}>
					<span>
						{canBeConvertedToNumber(record.precioBase)
							? `${addThousandsSeparators(
									record.cantidad *
										(record.precioBase * (1 + record.impuestoDecimal))
							  )}`
							: null}
					</span>
				</div>
			)
		},
		{
			title: '',
			key: 'action',
			render: (_, record) => (
				<div style={{ display: 'flex', justifyContent: 'center' }}>
					<Popconfirm
						title='¿Eliminar este registro?'
						cancelText='Cancelar'
						okText='Ok'
						onConfirm={() => handleDelete(record.key)}
					>
						<Button type='text' icon={<DeleteOutlined />} />
					</Popconfirm>
				</div>
			)
		}
	]

	const handleChange = (value, key, dataIndex) => {
		const newData = [...tableData]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
			if (dataIndex === 'articulo') {
				const item = items.filter(i => i.key === value)[0]
				target.precioBase = item.precioBase
				target.impuesto = item.impuesto
				target.impuestoDecimal = item.impuestoDecimal
			}

			setTableData(newData)
		}
	}

	const handleDelete = key => {
		const newData = tableData.filter(item => item.key !== key)
		setTableData(newData)
	}

	const handleAdd = () => {
		const newData = [...tableData]
		const emptyRows = tableData.some(o => o.articulo === null)
		const availableOptions = [
			...items.filter(i => !tableData.some(o => o.articulo === i.key))
		]

		if (availableOptions.length > 0 && !emptyRows) {
			setCount(prevCount => prevCount + 1)
			newData.push({
				key: count.toString(),
				articulo: null,
				cantidad: 1,
				precioBase: 0.0,
				impuesto: 'Exento',
				impuestoDecimal: 0.0
			})
			setTableData(newData)
			const lastPage = Math.ceil((newData.length + 1) / 5)
			setCurrentPage(lastPage)
		} else {
			openMessage('warning', 'No se pueden agregar nuevos registros')
		}
	}

	const loadviewModel = data => {
		const model = createPurchaseOrderFormModel()
		model.IdOrden = data.idOrden
		model.Numero = data.numero
		model.IdRequisicion = data.idRequisicion
		model.IdAlmacen = data.idAlmacen
		model.IdEstado = data.idEstado
		model.Estado = data.estado
		model.IdProveedor = data.idProveedor
		model.TipoPago = data.tipoPago
		model.FechaEstimada = data.fechaEstimada
		model.Notas = data.notas
		model.ArticulosDetalles = data.articulosDetalles.map(item => {
			return {
				IdArticulo: item.idArticulo,
				Cantidad: item.cantidad,
				IdImpuesto: item.idImpuesto,
				Impuesto: item.impuesto,
				ImpuestoDecimal: item.impuestoDecimal,
				PrecioBase: item.precioBase
			}
		})
		model.PagoDetalles = data.pagoDetalles.map(item => {
			return {
				Descripcion: item.descripcion,
				Tasa: item.tasa,
				Tipo: item.tipo,
				Valor: item.valor
			}
		})

		setLoading(false)
		setTimeout(() => {
			navigateToPath('/purchaseOrder', model)
		}, 200)
	}

	const approvePurchaseOrder = async id => {
		try {
			setLoading(true)
			const response = await axiosPrivate.post(APPROVE_PURCHASE_ORDER, id)
			const status = response?.status
			if (status === 200) {
				const data = response.data.data
				loadviewModel(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const archivePurchaseOrder = async id => {
		try {
			setLoading(true)
			const response = await axiosPrivate.post(ARCHIVE_PURCHASE_ORDER, id)
			const status = response?.status
			if (status === 200) {
				const data = response.data.data
				loadviewModel(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const discardPurchaseOrder = async id => {
		try {
			setLoading(true)
			const response = await axiosPrivate.post(DISCARD_PURCHASE_ORDER, id)
			const status = response?.status
			if (status === 200) {
				const data = response.data.data
				loadviewModel(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const savePurchaseOrder = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_PURCHASE_ORDER, model)
			if (response?.status === 200) {
				if (response.data.status === 'Ok') {
					const data = response.data.model

					loadviewModel(data)
				}
			}
		} catch (error) {
			console.log(error)
		} finally {
			setSaving(false)
		}
	}

	const handleSubmit = () => {
		form.submit()
	}

	const onFinish = values => {
		setSaving(true)
		const model = createPurchaseOrderFormModel()
		model.IdOrden = values.ordenId
		model.IdRequisicion = values.requisicionId
		model.IdAlmacen = values.almacenId
		model.IdProveedor = values.supplier
		model.TipoPago = values.paymentType
		model.FechaEstimada = values.fechaEstimada.format()
		model.Notas = values.notas

		model.ArticulosDetalles = tableData.map(a => {
			return {
				IdArticulo: a.articulo,
				Cantidad: a.cantidad,
				IdImpuesto: taxes.find(t => t.label === a.impuesto).key,
				Impuesto: a.impuesto,
				ImpuestoDecimal: a.impuestoDecimal,
				PrecioBase: a.precioBase
			}
		})

		model.PagoDetalles = detailsTableData.map(d => {
			return {
				Descripcion: d.descripcion,
				Tipo: d.tipo,
				Tasa: d.tasa,
				Valor: d.valor
			}
		})

		model.SubTotal = baseTotal
		model.TotalImpuestos = taxesTotal
		model.Total = finalTotal
		model.TotalAPagar = detailsTotal

		savePurchaseOrder(model)
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	const getPurchaseOrder = async () => {
		try {
			const response = await axiosPrivate.get(
				GET_ORDEN_COMPRA + `?id=${customState.IdOrden}`
			)
			if (response?.status === 200) {
				const data = response.data
				setItems(
					data.articulos.map(a => {
						return {
							...a,
							value: a.key,
							label: a.nombreCompleto
						}
					})
				)
				setWharehouse(
					data.almacenes.map(a => {
						return {
							key: a.key,
							value: a.key,
							label: a.almacen
						}
					})
				)
				setSuppliers(
					data.proveedores.map(p => {
						return {
							key: p.key,
							value: p.key,
							label: p.proveedor
						}
					})
				)
				setPaymentsTypes(
					data.tiposPagos.map(t => {
						return {
							key: t.key,
							value: t.key,
							label: t.tipoPago
						}
					})
				)
				setDetailsTypes(
					data.tiposDetalles.map(td => {
						return {
							key: td.key,
							value: td.key,
							label: td.tipoDetalle
						}
					})
				)
				setTaxes(
					data.impuestos.map(i => {
						return {
							key: i.key,
							value: i.value,
							label: i.label
						}
					})
				)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const loadPurchaseOrder = () => {
		const breadcrumbItems = [
			{
				title: (
					<a onClick={() => navigateToPath('/')}>
						<span className='breadcrumb-item'>
							<HomeOutlined />
						</span>
					</a>
				)
			},
			{
				title: (
					<a onClick={() => navigateToPath('/orders')}>
						<span className='breadcrumb-item'>Órdenes de compra</span>
					</a>
				)
			},
			{
				title: (
					<a onClick={() => {}}>
						<span className='breadcrumb-item'>{title}</span>
					</a>
				)
			}
		]

		handleBreadcrumb(breadcrumbItems)

		const newData = []
		let count = 0

		customState.ArticulosDetalles?.forEach(i => {
			if (items.some(item => item.key === i.IdArticulo)) {
				const item = {
					key: count.toString(),
					articulo: i.IdArticulo,
					cantidad: i.Cantidad,
					precioBase: i.PrecioBase,
					impuesto: i.Impuesto,
					impuestoDecimal: i.ImpuestoDecimal
				}
				newData.push(item)
				count++
			}
		})

		const newDetailsData = []
		let detailCount = 0

		customState.PagoDetalles?.forEach(i => {
			const item = {
				key: detailCount,
				descripcion: i.Descripcion,
				tipo: i.Tipo,
				tasa: i.Tasa,
				valor: i.Valor
			}
			newDetailsData.push(item)
			detailCount++
		})

		setCount(count)
		setTableData(newData)
		setDetailsTableData(newDetailsData)

		let date = new Date()
		if (customState.FechaEstimada) {
			date = new Date(customState.FechaEstimada)
		}

		form.setFieldsValue({
			requisicionId: customState.IdRequisicion,
			ordenId: customState.IdOrden,
			almacenId: customState.IdAlmacen !== 0 ? customState.IdAlmacen : null,
			supplier: customState.IdProveedor !== 0 ? customState.IdProveedor : null,
			paymentType: customState.TipoPago !== 0 ? customState.TipoPago : null,
			fechaEstimada: customState.FechaEstimada
				? moment(date, DATE_FORMAT)
				: null,
			notas: customState.Notas
		})

		setTimeout(() => {
			setLoaded(true)
		}, 1000)
	}

	useEffect(() => {
		const { state } = location
		setCustomState(state)

		document.title = 'Orden de compra'
	}, [validLogin, location])

	useEffect(() => {
		const interval = setInterval(() => {
			if (display && loaded) {
				handleLayoutLoading(false)
			}
		}, 500)
		return () => {
			clearInterval(interval)
		}
	}, [display, handleLayoutLoading, loaded])

	useEffect(() => {
		if (!validLogin) {
			navigateToPath('/login')
		}
	}, [validLogin, roles, navigateToPath])

	useEffect(() => {
		if (Object.keys(customState).length !== 0) {
			console.log(customState)
			if (customState.Numero) {
				setTitle(`Orden de Compra ${customState.Numero}`)
				setEnable(customState.IdEstado === 0 || customState.IdEstado === 1)
			}
			getPurchaseOrder()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

	useEffect(() => {
		loadPurchaseOrder()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [items, suppliers, wharehouses])

	useEffect(() => {
		const total = detailsTableData.reduce(
			(t, o) => t + o.valor * (o.tipo === 4 ? -1 : 1),
			0
		)
		setDetailsTotal(total)
	}, [detailsTableData])

	useEffect(() => {
		if (Object.keys(paymentDetailModalValues).length !== 0) {
			handlePaymentDetailModalStatus()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [paymentDetailModalValues])

	// Test

	// useEffect(() => {
	// 	console.log(detailsTypes)
	// }, [detailsTypes])

	// Test

	return (
		<>
			<PurchaseOrderPaymentDetailModal
				open={paymentDetailModalStatus}
				toggle={handlePaymentDetailModalStatus}
				basePayment={finalTotal}
				tableDataCount={detailsTableData.length}
				initialValues={paymentDetailModalValues}
				detailsTypes={detailsTypes}
				saveItem={handleSavePaymentDetail}
			/>
			<div className='page-content-container'>
				<div className='content-header'>
					<div style={{ display: 'flex', flexDirection: 'row' }}>
						<span className='title'>{title}</span>
						<Tag
							style={{
								display: 'flex',
								alignItems: 'center',
								marginLeft: '1rem'
							}}
							color={
								customState.IdEstado === 4
									? 'geekblue'
									: customState.IdEstado === 8
									? 'volcano'
									: ''
							}
						>
							{customState.IdEstado !== 0 ? customState.Estado : 'Nueva orden'}
						</Tag>
					</div>
					<div>
						{customState.IdEstado === 0 || customState.IdEstado === 1 ? (
							<>
								<Button
									icon={<SaveOutlined />}
									type='primary'
									onClick={handleSubmit}
									loading={saving}
								>
									Guardar
								</Button>
								{customState.IdEstado === 1 ? (
									<Popconfirm
										title='Aprobar orden'
										description='¿Desea aprobar esta orden de compra?'
										onConfirm={() => approvePurchaseOrder(customState.IdOrden)}
										onCancel={() => {}}
										okText='Aprobar'
										cancelText='Cancelar'
									>
										<Button
											style={{ marginLeft: '0.95rem' }}
											icon={<CheckOutlined />}
											loading={loading}
										>
											Aprobar
										</Button>
									</Popconfirm>
								) : null}
							</>
						) : null}

						{customState.IdEstado !== 0 && customState.IdEstado !== 1 ? (
							<>
								{customState.IdEstado === 4 ? (
									<Popconfirm
										title='Archivar orden'
										description='¿Desea archivar esta orden?'
										icon={<QuestionCircleOutlined style={{ color: 'red' }} />}
										onConfirm={() => archivePurchaseOrder(customState.IdOrden)}
										onCancel={() => {}}
										okText='Archivar'
										cancelText='Cancelar'
									>
										<Button
											style={{ marginLeft: '0.95rem' }}
											icon={<ContainerOutlined />}
											loading={loading}
										>
											Archivar
										</Button>
									</Popconfirm>
								) : null}
								<Popconfirm
									title='Descartar orden'
									description='¿Desea descartar esta orden?'
									icon={<QuestionCircleOutlined style={{ color: 'red' }} />}
									onConfirm={() => discardPurchaseOrder(customState.IdOrden)}
									onCancel={() => {}}
									okText='Archivar'
									cancelText='Cancelar'
								>
									<Button
										type='primary'
										style={{ marginLeft: '0.95rem' }}
										icon={<ContainerOutlined />}
										loading={loading}
										danger
									>
										Descartar
									</Button>
								</Popconfirm>
							</>
						) : null}
					</div>
				</div>
				<div
					className='body-container'
					style={{
						display: 'flex',
						flex: '1',
						flexDirection: 'column'
					}}
				>
					<div>
						<Form
							form={form}
							name='purchase_order_form'
							layout='vertical'
							onFinish={onFinish}
							onFinishFailed={onFinishFailed}
							requiredMark={false}
						>
							<Form.Item name='requisicionId' style={{ display: 'none' }}>
								<Input type='hidden' />
							</Form.Item>
							<Form.Item name='ordenId' style={{ display: 'none' }}>
								<Input type='hidden' />
							</Form.Item>
							<Row gutter={16}>
								<Col span={17}>
									<Form.Item
										name='almacenId'
										rules={[
											{
												required: true,
												message: 'Debe seleccionar un almacén para la entrega'
											}
										]}
									>
										<Select
											showSearch
											optionFilterProp='label'
											placeholder='Almacén'
											options={wharehouses}
											disabled={
												customState.IdRequisicion !== null ||
												customState.IdOrden !== 0
											}
										/>
									</Form.Item>
								</Col>
							</Row>
							<Row gutter={16}>
								<Col span={8}>
									<Form.Item
										name='supplier'
										rules={[
											{
												required: true,
												message: 'Debe seleccionar un proveedor'
											}
										]}
									>
										<Select
											showSearch
											optionFilterProp='label'
											placeholder='Proveedor'
											options={suppliers}
										/>
									</Form.Item>
								</Col>
								<Col span={5}>
									<Form.Item
										name='paymentType'
										rules={[
											{
												required: true,
												message: 'Debe seleccionar un método de pago'
											}
										]}
									>
										<Select
											showSearch
											optionFilterProp='label'
											placeholder='Tipo de pago'
											options={paymentsTypes}
										/>
									</Form.Item>
								</Col>
								<Col span={4}>
									<Form.Item
										name='fechaEstimada'
										rules={[
											{
												required: true,
												message: 'Debe ingresar una fecha estimada de entrega'
											}
										]}
									>
										<DatePicker
											placeholder='Fecha estimada'
											locale={locale}
											format={DATE_FORMAT}
											showTime={false}
										/>
									</Form.Item>
								</Col>
							</Row>
							<br />
							<Button icon={<PlusOutlined />} onClick={handleAdd}>
								Agregar artículo
							</Button>
							<br />
							<br />
							<Table
								dataSource={tableData}
								columns={columns}
								summary={() => (
									<Table.Summary>
										<Table.Summary.Row>
											<Table.Summary.Cell></Table.Summary.Cell>
											<Table.Summary.Cell></Table.Summary.Cell>
											<Table.Summary.Cell>
												<div>
													<span
														style={{ fontWeight: 'bold' }}
													>{`RD$ ${addThousandsSeparators(baseTotal)}`}</span>
												</div>
											</Table.Summary.Cell>
											<Table.Summary.Cell>
												<div>
													<span
														style={{ fontWeight: 'bold' }}
													>{`RD$ ${addThousandsSeparators(taxesTotal)}`}</span>
												</div>
											</Table.Summary.Cell>
											<Table.Summary.Cell>
												<div style={{ textAlign: 'end' }}>
													<span style={{ fontWeight: 'bold' }}>
														{`RD$ ${addThousandsSeparators(finalTotal)}`}
													</span>
												</div>
											</Table.Summary.Cell>
											<Table.Summary.Cell></Table.Summary.Cell>
										</Table.Summary.Row>
									</Table.Summary>
								)}
								pagination={{
									pageSize: 5,
									current: currentPage,
									onChange: page => setCurrentPage(page)
								}}
								rowKey='key'
								locale={{
									emptyText: customNoDataText
								}}
							/>
							<span className='subtitle'>Detalles del pago</span>
							<br />
							<br />
							<Row gutter={16}>
								<Col span={12}>
									<Form.Item
										name='notas'
										label={
											<span
												style={{
													fontWeight: 'bold',
													fontSize: '1rem',
													marginBottom: '1.3rem'
												}}
											>
												Notas
											</span>
										}
									>
										<Input.TextArea
											showCount
											maxLength={300}
											rows={4}
											placeholder='Escriba algo...'
										/>
									</Form.Item>
								</Col>
								<Col span={12}>
									<div>
										<Button
											icon={<PlusOutlined />}
											onClick={openPaymentDetailModal}
										>
											Agregar detalle
										</Button>
										<br />
										<br />
										<Table
											ref={detailsTableRef}
											key={detailsTableKey}
											loading={detailsTableStatus}
											columns={detailsColumns}
											dataSource={detailsTableData}
											summary={() => (
												<Table.Summary>
													<Table.Summary.Row>
														<Table.Summary.Cell></Table.Summary.Cell>
														<Table.Summary.Cell>
															<div style={{ textAlign: 'end' }}>
																<span style={{ fontWeight: 'bold' }}>
																	Total a pagar
																</span>
															</div>
														</Table.Summary.Cell>
														<Table.Summary.Cell>
															<div style={{ textAlign: 'end' }}>
																<span style={{ fontWeight: 'bold' }}>
																	{`RD$ ${addThousandsSeparators(
																		detailsTotal
																	)}`}
																</span>
															</div>
														</Table.Summary.Cell>
														<Table.Summary.Cell></Table.Summary.Cell>
													</Table.Summary.Row>
												</Table.Summary>
											)}
										/>
									</div>
								</Col>
							</Row>

							{/* <Row gutter={16}>
								<Col span={24}>
									<Form.Item name='notas'>
										<Input.TextArea
											showCount
											maxLength={300}
											rows={4}
											placeholder='Notas...'
										/>
									</Form.Item>
								</Col>
							</Row> */}
							<br />
							<br />
						</Form>
					</div>
				</div>
			</div>
		</>
	)
}

export default PurchaseOrder
