import {
	AppstoreOutlined,
	CaretDownOutlined,
	DownloadOutlined,
	FormOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import {
	Button,
	Card,
	Dropdown,
	Progress,
	Space,
	Statistic,
	Tag,
	Timeline,
	Tooltip,
	Typography
} from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import CountUp from 'react-countup'
import { useLocation, useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import {
	createInventoryEntryModel,
	createWharehouseSectionModel,
	createWharehouseSectionStockModel
} from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useItemStates from '../hooks/useItemStates'
import useItems from '../hooks/useItems'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useWharehouseStates from '../hooks/useWharehouseStates'
import useZonesTypes from '../hooks/useZonesTypes'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import WharehouseInvetoryEntryForm from './WharehouseInventoryEntryForm'
import WharehouseSectionForm from './WharehouseSectionForm'
import WharehouseSectionStockForm from './WharehouseSectionStockForm'
import WharehouseSectionStockModal from './WharehouseSectionStockModal'

const formatter = value => <CountUp end={value} duration={2} />
const { Text } = Typography

const ALMACEN_GET = '/api/almacenes/getAlmacen'
const ALMACENES_SECCIONES_URL = '/api/data/getAlmacenSecciones'
const ALMACENES_SECCIONES_ESTANTERIAS_URL =
	'/api/data/getAlmacenSeccionesEstanterias'
const ARTICULOS_MARCAS_URL = '/api/data/getMarcasArticulos'
const ARTICULOS_IMPUESTOS_URL = '/api/data/getImpuestosArticulos'

const sectionMenuOptions = [
	{
		key: '0',
		label: 'Editar'
	},
	{
		key: '1',
		label: 'Nueva estantería'
	}
]

const sectionStockMenuOptions = [
	{
		key: '0',
		label: 'Nueva entrada',
		icon: <DownloadOutlined />
	},
	{
		key: '1',
		label: 'Existencias',
		icon: <AppstoreOutlined />
	}
]

// const customNoDataText = (
// 	<Empty
// 		image={Empty.PRESENTED_IMAGE_SIMPLE}
// 		description='No existen registros'
// 	/>
// )

// const timeLine = [
// 	{
// 		children: (
// 			<p>
// 				<span style={{ fontWeight: '500' }}>{text}</span>
// 				<br />
// 				<span style={{ fontWeight: '300' }}>8/10/2023 12:09 PM</span>
// 			</p>
// 		)
// 	},
// 	{
// 		children: (
// 			<p>
// 				<span style={{ fontWeight: '500' }}>OC-122 - Título de la compra</span>
// 				<br />
// 				<span style={{ fontWeight: '300' }}>8/10/2023 12:09 PM</span>
// 			</p>
// 		)
// 	},
// 	{
// 		color: 'grey',
// 		children: (
// 			<p>
// 				<span style={{ fontWeight: '500' }}>{text}</span>
// 				<br />
// 				<span style={{ fontWeight: '300' }}>8/10/2023 12:09 PM</span>
// 			</p>
// 		)
// 	}
// ]

const Wharehouse = () => {
	const location = useLocation()
	const navigate = useNavigate()
	const [customState, setCustomState] = useState(null)

	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const wharehouseStates = useWharehouseStates().items
	const [viewModel, setViewModel] = useState({})

	const [wharehouseData, setWharehouseData] = useState({})
	const [sections, setSections] = useState([])
	const [shelvesInUse, setShelvesInUse] = useState(0)
	const [shelves, setShelves] = useState(0)
	const [stock, setStock] = useState(0)
	const [requests, setRequests] = useState([])
	const [procurementOrders, setProcurementOrders] = useState([])
	const [pendingOrders, setPendingOrders] = useState([])
	const [timelineItems, setTimelineItems] = useState([])

	const [tableState, setTableState] = useState(true)
	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())

	const [pendingTableState, setPendingTableState] = useState(true)
	const pendingTableRef = useRef()
	const [pendingTableKey, setPendingTableKey] = useState(Date.now())

	// Section Form

	const zonesTypes = useZonesTypes().items
	const [sectionFormValues, setSectionFormValues] = useState(
		createWharehouseSectionModel()
	)

	const [openSectionForm, setOpenSectionForm] = useState(false)
	const [sectionFormLoading, setSectionFormLoading] = useState(false)
	const [sectionLoading, setSectionLoading] = useState({})

	const handleOpenSectionForm = value => {
		setOpenSectionForm(value)
	}

	const handleSectionFormLoading = value => {
		setSectionFormLoading(value)
	}

	const handleSectionForm = rowId => {
		setSectionLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getWharehouseSection(rowId)
	}

	const getWharehouseSection = id => {
		const section = sections.filter(s => s.idAlmacenSeccion === id)[0]
		const model = createWharehouseSectionModel()
		model.IdAlmacen = wharehouseData.idAlmacen
		model.IdSeccion = section.idAlmacenSeccion
		model.IdTipoZona = section.idTipoZona
		model.Seccion = section.seccion
		model.IdEstado = section.idEstado
		setSectionFormValues(model)
		setOpenSectionForm(true)
		setSectionLoading(prevState => ({
			...prevState,
			[id]: false
		}))
	}

	useEffect(() => {
		if (!openSectionForm) {
			loadWharehouseData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [openSectionForm])

	// Section Form

	// Stock Form

	const items = useItems().items
	const [idSectionStock, setIdSectionStock] = useState(0)
	const [stockFormValues, setStockFormValues] = useState(
		createWharehouseSectionStockModel()
	)

	const [openStockForm, setOpenStockForm] = useState(false)
	const [stockFormLoading, setStockFormLoading] = useState(false)
	const [stockLoading, setStockLoading] = useState({})

	const handleOpenStockForm = value => {
		setOpenStockForm(value)
	}

	const handleStockFormLoading = value => {
		setStockFormLoading(value)
	}

	const handleStockForm = (idSec, idStock) => {
		setStockLoading(prevState => ({
			...prevState,
			[idStock]: true
		}))
		getWharehouseSectionStock(idSec, idStock)
	}

	const getWharehouseSectionStock = (idSec, idStock) => {
		const stock = sections
			.filter(s => s.key === idSec)[0]
			.estanterias.filter(e => e.key === idStock)[0]
		console.log(stock, items)
		const model = createWharehouseSectionStockModel()
		model.IdSeccion = idSec
		model.IdEstanteria = idStock
		model.Codigo = stock.codigo
		model.IdEstado = stock.idEstado
		setStockFormValues(model)

		// setSectionFormValues(model)
		console.log(model)

		setOpenStockForm(true)
		setStockLoading(prevState => ({
			...prevState,
			[idStock]: false
		}))
	}

	const handleNewSectionStock = idSection => {
		setIdSectionStock(idSection)
	}

	useEffect(() => {
		if (idSectionStock !== 0) {
			setOpenStockForm(true)
		}
		// console.log(idSeccion)
	}, [idSectionStock])

	useEffect(() => {
		if (!openStockForm) {
			loadWharehouseData()
			setIdSectionStock(0)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [openStockForm])

	// Stock Form

	// Inventory Entry Form

	const itemStates = useItemStates().items
	const [wharehouseSections, setWharehouseSections] = useState(null)

	const getWharehouseSections = async () => {
		try {
			const response = await axiosPrivate.get(ALMACENES_SECCIONES_URL)
			const items = response?.data.items
			setWharehouseSections(items)
		} catch (error) {
			console.log(error)
		}
	}

	const [sectionShelves, setSectionShelves] = useState(null)

	const getWharehouseSectionShelves = async () => {
		try {
			const response = await axiosPrivate.get(
				ALMACENES_SECCIONES_ESTANTERIAS_URL
			)
			const items = response?.data.items
			setSectionShelves(items)
		} catch (error) {
			console.log(error)
		}
	}

	const [brands, setBrands] = useState(null)

	const getBrands = async () => {
		try {
			const response = await axiosPrivate.get(ARTICULOS_MARCAS_URL)
			const items = response?.data.items
			setBrands(items)
		} catch (error) {
			console.log(error)
		}
	}

	const [taxes, setTaxes] = useState(null)

	const getTaxes = async () => {
		try {
			const response = await axiosPrivate.get(ARTICULOS_IMPUESTOS_URL)
			const items = response?.data.items
			setTaxes(items)
		} catch (error) {
			console.log(error)
		}
	}

	const [buttonInventoryEntryLoading, setButtonInventoryEntryLoading] =
		useState(false)
	const [openInventoryEntryForm, setOpenInventoryEntryForm] = useState(false)
	const [inventoryEntryFormLoading, setInventoryEntryFormLoading] =
		useState(false)
	// const [stockLoading, setStockLoading] = useState({})

	const handleOpenInventoryEntryForm = value => {
		// setOpenInventoryEntryForm(value)
		if (value) {
			setButtonInventoryEntryLoading(value)
			getWharehouseSections()
			getWharehouseSectionShelves()
			getBrands()
			getTaxes()
		} else {
			setWharehouseSections(null)
			setSectionShelves(null)
			setBrands(null)
			setTaxes(null)
			setOpenInventoryEntryForm(value)
		}
	}

	useEffect(() => {
		if (
			wharehouseSections !== null &&
			sectionShelves !== null &&
			brands !== null &&
			taxes !== null &&
			itemStates !== null
		) {
			// console.log(wharehouseSections, sectionShelves, brands, taxes, itemStates)
			setButtonInventoryEntryLoading(false)
			setOpenInventoryEntryForm(true)
		}
	}, [wharehouseSections, sectionShelves, brands, taxes, itemStates])

	const handleInventoryEntryFormLoading = value => {
		setInventoryEntryFormLoading(value)
	}

	// const handleStockForm = (idSec, idStock) => {
	// 	setStockLoading(prevState => ({
	// 		...prevState,
	// 		[idStock]: true
	// 	}))
	// 	getWharehouseSectionStock(idSec, idStock)
	// }

	// Inventory Entry Form

	// Wharehouse Info Form

	const handleShowInfo = () => {
		console.log(wharehouseData)
	}

	// Wharehouse Info Form

	// Wharehouse Modal

	const [wharehouseSectionStockModalData, setWharehouseSectionStockModalData] =
		useState({})
	const [
		wharehouseSectionStockModalStatus,
		setWharehouseSectionStockModalStatus
	] = useState(false)
	const [tableStockModalKey, setTableStockModalKey] = useState(Date.now())
	const tableStockModalRef = useRef()

	const handleStockModalTableKey = () => {
		setTableStockModalKey(Date.now())
	}

	const handleLoadStockModalData = childRecord => {
		console.log(childRecord)
		setWharehouseSectionStockModalData(childRecord)
	}

	const handleStockModalStatus = () => {
		setWharehouseSectionStockModalStatus(!wharehouseSectionStockModalStatus)
	}

	useEffect(() => {
		if (!wharehouseSectionStockModalStatus) {
			setWharehouseSectionStockModalData({})
		}
	}, [wharehouseSectionStockModalStatus])

	useEffect(() => {
		if (Object.keys(wharehouseSectionStockModalData).length !== 0) {
			handleStockModalStatus()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [wharehouseSectionStockModalData])

	// Wharehouse Modal

	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				console.log(column)
				column.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const expandedRowRender = record => {
		const expandedColumns = [
			{
				title: 'Código',
				dataIndex: 'codigo',
				key: 'codigo'
			},
			{
				title: 'Estado',
				key: 'estado',
				render: (_, childRecord) => (
					<Tag color={childRecord.idEstado === 1 ? 'geekblue' : 'volcano'}>
						{childRecord.estado}
					</Tag>
				)
			},
			// {
			// 	title: 'Artículo',
			// 	key: 'artículo',
			// 	render: (_, childRecord) => (
			// 		<span>{`${childRecord.articulo} (${childRecord.codigoArticulo})`}</span>
			// 	)
			// },
			// {
			// 	title: 'Unidad',
			// 	dataIndex: 'unidadMedida',
			// 	key: 'unidadMedida'
			// },
			// {
			// 	title: 'Capacidad',
			// 	dataIndex: 'capacidadMaxima',
			// 	key: 'capacidadMaxima'
			// },
			// {
			// 	title: 'Mínimo Req.',
			// 	dataIndex: 'minimoRequerido',
			// 	key: 'minimoRequerido'
			// },
			// {
			// 	title: 'Existencias',
			// 	dataIndex: 'existencias',
			// 	key: 'existencias'
			// },
			{
				title: '',
				key: 'action',
				render: (_, childRecord) => (
					<Space
						size='middle'
						align='center'
						styles={{
							width: '100%',
							display: 'flex',
							flexDirection: 'row',
							justifyContent: 'center'
						}}
					>
						{/* <Button
							type='link'
							onClick={() => {
								handleStockForm(record.key, childRecord.key)
							}}
							loading={stockLoading[childRecord.key]}
						>
							Editar
						</Button> */}
						<Dropdown.Button
							menu={{
								items: sectionStockMenuOptions,
								onClick: ({ key }) => {
									switch (key) {
										case '0':
											console.log(key)
											break
										case '1':
											handleLoadStockModalData(childRecord)
											break
										default:
											break
									}
									console.log(key)
								}
							}}
							onClick={() => {
								handleStockForm(record.key, childRecord.key)
							}}
							loading={stockLoading[childRecord.key]}
							icon={<CaretDownOutlined />}
						>
							Editar
						</Dropdown.Button>
					</Space>
				)
			}
		]
		return (
			<CustomTable
				data={record.estanterias}
				columns={expandedColumns}
				scrollable={false}
				pagination={false}
			/>
		)
	}

	const columns = [
		{
			title: 'Sección',
			dataIndex: 'seccion',
			key: 'seccion'
		},
		{
			title: 'Tipo de zona',
			dataIndex: 'tipoZonaAlmacenamiento',
			key: 'tipoZonaAlmacenamiento'
		},
		{
			title: 'Estado',
			key: 'estado',
			render: (_, record) => (
				<Tag color={record.idEstado === 1 ? 'geekblue' : 'volcano'}>
					{record.estado}
				</Tag>
			)
		},
		{
			title: '',
			key: 'accion',
			render: (_, record) => (
				<Space
					align='center'
					style={{
						width: '100%',
						display: 'flex',
						flexDirection: 'row',
						justifyContent: 'center'
					}}
				>
					<Dropdown
						menu={{
							items: sectionMenuOptions,
							onClick: ({ key }) => {
								switch (key) {
									case '0':
										handleSectionForm(record.key)
										break
									case '1':
										handleNewSectionStock(record.key)
										break
									default:
										break
								}
							}
						}}
					>
						<Button
							type='link'
							icon={<CaretDownOutlined />}
							loading={sectionLoading[record.key]}
						></Button>
					</Dropdown>
				</Space>
			)
		}
	]

	const pendingColumns = [
		{
			title: 'Codigo',
			dataIndex: 'codigo',
			key: 'codigo',
			width: 90
		},
		{
			title: 'Proveedor',
			dataIndex: 'proveedor',
			key: 'proveedor',
			width: 180,
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Total',
			dataIndex: 'total',
			key: 'total',
			width: 150
		},
		{
			title: 'Fecha Estimada',
			dataIndex: 'fecha',
			key: 'fecha',
			width: 140
		},
		{
			title: 'Acciones',
			dataIndex: 'accion',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Button>Detalle</Button>
				</Space>
			)
		}
	]

	const loadWharehouseData = async () => {
		try {
			const response = await axiosPrivate.get(
				ALMACEN_GET + `?id=${customState}`
			)

			if (response?.status === 200) {
				const data = response?.data
				console.log(data)
				setViewModel(data)

				setWharehouseData(data.almacen)
				setSections(data.secciones)

				let shelves = 0
				let shelvesInUSe = 0

				data.secciones.forEach(seccion => {
					shelves += seccion.estanterias.length
					shelvesInUSe += seccion.estanterias.filter(
						e => e.existencias > 0 && e.idEstado === 1
					).length
				})

				setShelves(shelves)
				setShelvesInUse(shelvesInUSe)

				setRequests(data.solicitudesMateriales)
				setProcurementOrders(data.ordenesCompras)

				const sectionFormModelValues = createWharehouseSectionModel()
				sectionFormModelValues.IdAlmacen = data.almacen.idAlmacen
				setSectionFormValues(sectionFormModelValues)

				setTableState(false)
			}
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		const { state } = location
		setCustomState(state)

		document.title = 'Almacén'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/wharehouses')}>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Almacenes</span>
							</span>
						</a>
					)
				},
				{
					title: (
						<a>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Almacén</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [location])

	useEffect(() => {
		loadWharehouseData()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

	useEffect(() => {
		setPendingOrders(procurementOrders)
		const items = []
		procurementOrders.forEach(o => {
			const timelineItem = {
				children: (
					<p>
						<span style={{ fontWeight: '500' }}>{o.IdOrdenCompra}</span>
						<br />
						<span style={{ fontWeight: '300' }}>{o.IdDocumento}</span>
					</p>
				)
			}
			items.push(timelineItem)
		})

		if (items.length === 0) {
			items.push({
				color: 'grey',
				children: (
					<p>
						<span style={{ fontWeight: '500' }}>No existen registros</span>
						<br />
						<span style={{ fontWeight: '300' }}>
							{/* {moment().format('DD/M/YYYY')} */}
							__/__/____
						</span>
					</p>
				)
			})
		}

		setTimelineItems(items)
		setPendingTableState(false)
	}, [procurementOrders])

	return (
		<>
			<div className='page-content-container'>
				<WharehouseSectionForm
					initialValues={sectionFormValues}
					zonesTypes={zonesTypes}
					wharehouseStates={wharehouseStates}
					open={openSectionForm}
					handleOpen={handleOpenSectionForm}
					loading={sectionFormLoading}
					handleLoading={handleSectionFormLoading}
				/>
				<WharehouseSectionStockForm
					idSectionStock={idSectionStock}
					initialValues={stockFormValues}
					wharehouseStates={wharehouseStates}
					items={items}
					open={openStockForm}
					handleOpen={handleOpenStockForm}
					loading={stockFormLoading}
					handleLoading={handleStockFormLoading}
				/>
				<WharehouseSectionStockModal
					status={wharehouseSectionStockModalStatus}
					toggle={handleStockModalStatus}
					tableKey={tableStockModalKey}
					handleTableKey={handleStockModalTableKey}
					tableRef={tableStockModalRef}
					data={wharehouseSectionStockModalData}
				/>
				<WharehouseInvetoryEntryForm
					wharehouseSections={wharehouseSections}
					sectionShelves={sectionShelves}
					registereditems={items}
					itemStates={itemStates}
					brands={brands}
					taxes={taxes}
					initialValues={createInventoryEntryModel()}
					open={openInventoryEntryForm}
					handleOpen={handleOpenInventoryEntryForm}
					loading={inventoryEntryFormLoading}
					handleLoading={handleInventoryEntryFormLoading}
					handleRefreshData={loadWharehouseData}
				/>
				<div className='outter-info-container'>
					<div className='info-container'>
						<div className='info-statistic'>
							<Text
								style={{
									fontSize: '1rem',
									fontWeight: '500',
									marginBottom: '1.5rem',
									color: '#8c8c8c'
								}}
							>
								Solicitudes de materiales
							</Text>
							<Tooltip title='3 En proceso / 7 Por procesar' placement='bottom'>
								<Progress
									type='dashboard'
									status='active'
									percent={0}
									size={100}
								/>
							</Tooltip>
						</div>
						<div className='info-statistic'>
							<Text
								type='secondary'
								style={{
									fontSize: '1rem',
									fontWeight: '500',
									marginBottom: '1.5rem',
									color: '#8c8c8c'
								}}
							>
								Ordenes de compra
							</Text>
							<Tooltip
								title='2 Procesados / 4 En proceso / 4 En espera de entrega'
								placement='bottom'
							>
								<Progress
									type='dashboard'
									status='active'
									percent={0}
									success={{
										percent: 0
									}}
									size={100}
								/>
							</Tooltip>
						</div>
					</div>
					<div className='info-container info-container-remaning-space'>
						<div style={{ marginRight: '3rem' }}>
							<Statistic
								title='Secciones en uso'
								value={sections.filter(s => s.idEstado === 1).length}
								formatter={formatter}
							/>
						</div>
						<div style={{ marginRight: '3rem' }}>
							<Statistic
								title='Estanterías en uso'
								value={shelvesInUse}
								suffix={`/${shelves}`}
							/>
						</div>
						<div style={{ marginRight: '3rem' }}>
							<Statistic
								title='Tol. Artículos (Unidad)'
								value={stock}
								formatter={formatter}
							/>
						</div>
					</div>
					<div className='info-container'>
						<Button type='dashed' onClick={handleShowInfo}>
							Información General
						</Button>
					</div>
				</div>
				<div className='main-one-container'>
					<div>
						<div style={{ marginBottom: '1.5rem' }}>
							<span
								style={{
									fontSize: '1rem',
									fontWeight: '500',
									color: '#8c8c8c'
								}}
							>
								Ordenes de compra pendientes
							</span>
						</div>
						<CustomTable
							tableKey={pendingTableKey}
							tableRef={pendingTableRef}
							tableState={pendingTableState}
							tableClases='custom-table-style no-hover'
							columns={pendingColumns}
							dataSource={pendingOrders}
							scrollable={false}
						/>
					</div>
					<div style={{ width: '30%' }}>
						<div style={{ marginBottom: '1.5rem' }}>
							<span
								style={{
									fontSize: '1rem',
									fontWeight: '500',
									color: '#8c8c8c'
								}}
							>
								Historial de ordenes de compra
							</span>
						</div>
						<Card className='always-lifted-card'>
							<Timeline items={timelineItems} size='large' />
						</Card>
					</div>
				</div>
				<div className='main-two-container'>
					<div className='actions'>
						<Button
							type='primary'
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<PlusOutlined />}
							onClick={() => {
								setOpenSectionForm(true)
							}}
						>
							Agregar sección
						</Button>
						<Button
							type='primary'
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<FormOutlined />}
							onClick={() => {
								handleOpenInventoryEntryForm(true)
							}}
							loading={buttonInventoryEntryLoading}
						>
							Nueva entrada de inventario
						</Button>
						<Button
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<ReloadOutlined />}
							onClick={handleFiltersReset}
						>
							Limpiar Filtros
						</Button>
					</div>
					<div className='container-content'>
						<CustomTable
							tableKey={tableKey}
							tableRef={tableRef}
							tableState={tableState}
							expandedRowRender={expandedRowRender}
							data={sections}
							columns={columns}
							scrollable={false}
							pagination={false}
						/>
					</div>
					<br />
					<br />
					<br />
				</div>
			</div>
		</>
	)
}

export default Wharehouse
