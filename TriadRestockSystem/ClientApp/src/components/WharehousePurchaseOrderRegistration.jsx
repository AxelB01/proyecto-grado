import { HomeOutlined, SaveOutlined } from '@ant-design/icons'
import {
	Button,
	Cascader,
	Descriptions,
	Empty,
	Input,
	Table,
	Tag,
	notification
} from 'antd'
import 'moment/locale/es'
import moment from 'moment/moment'
import { useContext, useEffect, useState } from 'react'
import { useLocation } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createWharehousePurchaseOrderRegistrationModel } from '../functions/constructors'
import {
	findDuplicates,
	hasDuplicates,
	isStringEmpty
} from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const GET_PURCHASE_ORDER_DATA = '/api/almacenes/ordenCompraDetallesRegistro'
const SAVE_REGISTRATION_DATA = 'api/almacenes/saveOrdenCompraDetallesRegistro'

const WharehousePurchaseOrderRegistration = () => {
	const location = useLocation()
	const [customState, setCustomState] = useState({})
	const [loaded, setLoaded] = useState(false)

	const [api, contextHolder] = notification.useNotification()
	const openNotification = (titleMessage, descriptionMessage) => {
		api.info({
			message: titleMessage,
			description: descriptionMessage
		})
	}

	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayoutLoading,
		handleBreadcrumb,
		openMessage,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()

	const [title, setTitle] = useState('')
	const [wharehouseId, setWharehouseId] = useState(0)
	const [wharehouse, setWharehouse] = useState('')
	const [positions, setPositions] = useState([])

	const [orderDetails, setOrderDetails] = useState({})

	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)
	const [currentPage, setCurrentPage] = useState(1)

	const saveItems = async () => {
		setLoading(true)
		const itemsToSave = data.filter(
			item => !isStringEmpty(item.serie) && item.posicion != null
		)
		if (hasDuplicates(itemsToSave, 'serie')) {
			const duplicatedItems = findDuplicates(itemsToSave, 'serie')
			let listOfCodes = 'Los siguientes registros tienen duplicado el código: '
			duplicatedItems.forEach((item, index) => {
				let text = `${item.key}, `
				if (index + 1 === duplicatedItems.length) {
					text = `${item.key}`
				}
				listOfCodes += text
			})
			openNotification('Error de registro', listOfCodes)
		} else {
			const model = createWharehousePurchaseOrderRegistrationModel()
			model.IdOrden = customState.Id
			model.Articulos = itemsToSave.map(i => {
				return {
					IdArticulo: i.idArticulo,
					Codigo: i.serie,
					Posicion: i.posicion[1],
					Notas: i.notas
				}
			})
			try {
				const response = await axiosPrivate.post(SAVE_REGISTRATION_DATA, model)
				if (response?.status === 200) {
					const data = response.data
					if (!isStringEmpty(data.message)) {
						openNotification('Registro incompleto', data.message)
					} else {
						if (isStringEmpty(data.message) && data.count > 0) {
							openNotification(
								'Registro incompleto',
								'Aún existen hay por registrar'
							)
						}
					}
					if (data.closed) {
						setLoading(false)
						openMessage('success', 'Orden de compra registrada', 5)
						navigateToPath('/wharehouse', { Id: wharehouseId })
					} else {
						setLoading(false)
						navigateToPath('/wharehousePurchaseOrderRegistration', {
							Id: customState.Id
						})
					}
				}
			} catch (error) {
				console.log(error)
			}
		}
	}

	const loadPurchaseOrderDetails = async () => {
		try {
			const response = await axiosPrivate.get(
				GET_PURCHASE_ORDER_DATA + `?id=${customState.Id}`
			)
			if (response?.status === 200) {
				const data = response.data
				console.log(response.data)
				setWharehouseId(data.idAlmacen)
				setWharehouse(data.almacen)
				setTitle(`Orden de Compra ${data.numero}`)
				setPositions(data.posicion)
				loadTableData(response.data.detalles)

				setOrderDetails({
					Proveedor: `${data.nombre} (#${data.idProveedor})`,
					Rnc: data.proveedorRNC,
					Factura: data.factura,
					FechaFactura: moment(new Date(data.fechaFactura))
						.locale('es')
						.format('dddd D [de] MMMM, YYYY'),
					FechaEntrega: moment(new Date(data.fechaEntrega))
						.locale('es')
						.format('dddd D [de] MMMM, YYYY')
				})
			}
		} catch (error) {
			console.log(error)
		}
	}

	const loadTableData = sourceData => {
		const tableData = []
		let count = 1
		sourceData.forEach(detail => {
			const detailName = `${detail.articulo} (${detail.marca})`
			for (let i = 0; i < detail.cantidad; i++) {
				const element = {
					key: count.toString(),
					numero: count.toString(),
					articulo: detailName,
					idArticulo: detail.idArticulo,
					familia: detail.familia,
					serie: null,
					posicion: null,
					notas: null
				}
				tableData.push(element)
				count++
			}
		})
		// console.log(tableData)
		setData(tableData)
	}

	const pageRenderer = () => {
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
					<a onClick={() => navigateToPath('/wharehouses')}>
						<span className='breadcrumb-item'>Almacenes</span>
					</a>
				)
			},
			{
				title: (
					<a
						onClick={() => navigateToPath('/wharehouse', { Id: wharehouseId })}
					>
						<span className='breadcrumb-item'>{wharehouse}</span>
					</a>
				)
			},
			{
				title: (
					<a>
						<span className='breadcrumb-item'>{title}</span>
					</a>
				)
			}
		]

		handleBreadcrumb(breadcrumbItems)

		setTimeout(() => {
			setLoaded(true)
		}, 500)
	}

	const handleChange = (value, key, dataIndex) => {
		const newData = [...data]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
		}
		setData(newData)
	}

	useEffect(() => {
		pageRenderer()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [wharehouseId, wharehouse])

	useEffect(() => {
		const { state } = location
		setCustomState(state)

		document.title = 'Orden de Compra - Registro'
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
			loadPurchaseOrderDetails()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

	const descriptionItems = [
		{
			key: '1',
			label: 'Proveedor',
			children: (
				<span style={{ fontWeight: 'bold' }}>{orderDetails?.Proveedor}</span>
			),
			span: 2
		},
		{
			key: '2',
			label: 'RNC',
			children: <span style={{ fontWeight: 'bold' }}>{orderDetails?.Rnc}</span>
		},
		{
			key: '3',
			label: 'Factura',
			children: <span>Prueba</span>
		},
		{
			key: '4',
			label: 'Fecha Factura',
			children: <span>{orderDetails?.FechaFactura} </span>
		},
		{
			key: '5',
			label: 'Fecha Entrega',
			children: <span>{orderDetails?.FechaEntrega}</span>
		}
	]

	const columns = [
		{
			title: 'No.',
			dataIndex: 'numero',
			key: 'numero',
			width: 60,
			render: text => (
				<div style={{ textAlign: 'end' }}>
					<span style={{ fontWeight: 'bold' }}>#{text}</span>
				</div>
			)
		},
		{
			title: 'Artículo',
			dataIndex: 'articulo',
			key: 'articulo',
			width: 240
		},
		{
			title: 'Familia',
			dataIndex: 'familia',
			key: 'familia',
			width: 180,
			render: text => <Tag>{text}</Tag>
		},
		{
			title: 'Código de barras',
			dataIndex: 'serie',
			key: 'serie',
			width: 250,
			render: (text, record) => (
				<span style={{ display: 'flex', justifyContent: 'center' }}>
					<Input
						value={text}
						onChange={e => handleChange(e.target.value, record.key, 'serie')}
						placeholder='Ingresar código'
					/>
				</span>
			)
		},
		{
			title: 'Posición',
			dataIndex: 'posicion',
			key: 'posicion',
			width: 220,
			render: (value, record) => (
				<Cascader
					showSearch
					style={{ width: 220 }}
					options={positions}
					value={value}
					onChange={value => handleChange(value, record.key, 'posicion')}
					placeholder='Seleccionar posición'
				/>
			)
		},
		{
			title: 'Notas',
			dataIndex: 'notas',
			key: 'notas',
			width: 240,
			render: (value, record) => (
				<Input
					value={value}
					onChange={e => handleChange(e.target.value, record.key, 'notas')}
					placeholder='Notas...'
				/>
			)
		}
	]

	return (
		<>
			{contextHolder}
			<div className='page-content-container'>
				<div className='content-header'>
					<div style={{ display: 'flex', flexDirection: 'row' }}>
						<span className='title'>{title}</span>
					</div>
					<div>
						<Button
							type='primary'
							icon={<SaveOutlined />}
							onClick={saveItems}
							loading={loading}
						>
							Guardar
						</Button>
					</div>
				</div>
				<div className='body-container'>
					<Descriptions
						title='Detalles de la orden'
						bordered
						items={descriptionItems}
					/>
					<br />
					<Table
						dataSource={data}
						columns={columns}
						pagination={{
							pageSize: 10,
							current: currentPage,
							onChange: page => setCurrentPage(page)
						}}
						rowKey='key'
						locale={{
							emptyText: customNoDataText
						}}
					/>
				</div>
			</div>
		</>
	)
}

export default WharehousePurchaseOrderRegistration
