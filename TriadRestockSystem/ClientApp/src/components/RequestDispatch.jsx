import {
	HomeOutlined,
	ReconciliationOutlined,
	SendOutlined
} from '@ant-design/icons'
import {
	Button,
	Descriptions,
	Empty,
	InputNumber,
	Popconfirm,
	Space,
	Table,
	Tooltip
} from 'antd'
import 'moment/locale/es'
import moment from 'moment/moment'
import { useContext, useEffect, useState } from 'react'
import { useLocation } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createWharehouseRequestDispatchModel } from '../functions/constructors'
import { addThousandsSeparators, isStringEmpty } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import RequestDispatchModel from './RequestDispatchModel'

const GET_REQUEST_DISPATCH_DATA =
	'/api/almacenes/cargarSolicitudMaterialesDespacho'

const SAVE_REQUEST_DISPATCH = '/api/almacenes/despacharSolicitudMateriales'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const RequestDispatch = () => {
	const location = useLocation()
	const [customState, setCustomState] = useState({})
	const [loaded, setLoaded] = useState(false)
	const [loading, setLoading] = useState(false)

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
	const [wharehouse, setWharehouse] = useState({})
	const [request, setRequest] = useState({})

	const [items, setItems] = useState([])
	const [modalSource, setModalSource] = useState([])
	const [data, setData] = useState([])
	const [loadings, setLoadings] = useState({})
	const [total, setTotal] = useState(0)
	const [currentPage, setCurrentPage] = useState(1)

	const [requestDispatchModalStatus, setRequestDispatchModalStatus] =
		useState(false)
	const [initialValuesModal, setInitialValuesModal] = useState({})

	const handleRequestDispatchModelStatus = () => {
		setRequestDispatchModalStatus(!requestDispatchModalStatus)

		if (!requestDispatchModalStatus) {
			setInitialValuesModal({})
		}
	}

	const handleChange = (value, key, dataIndex) => {
		const newData = [...data]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
			target.total = target.costo * target.despachar
			target.articulos = items
				.filter(i => i.item === target.idArticulo)
				.map(i => {
					return i.key
				})
				.slice(0, target.despachar)
		}
		setData(newData)
	}

	const saveItemData = model => {
		console.log(model, data)
		const newData = [...data]
		const target = newData.find(item => item.key === model.id)
		if (target) {
			target.articulos = model.detalle
			target.despachar = model.detalle.length
			target.total = target.costo * target.despachar
		}
		setData(newData)
	}

	const handleSpecificItemsSelection = record => {
		setLoadings(prevState => ({
			...prevState,
			[record.key]: true
		}))
		setInitialValuesModal({
			id: record.key,
			title: record.articuloCompleta,
			selected: record.articulos
		})
		setModalSource(items.filter(i => i.item === record.idArticulo))
	}

	const loadRequestDispatchDetails = async () => {
		try {
			const response = await axiosPrivate.get(
				GET_REQUEST_DISPATCH_DATA +
					`?idSolicitud=${customState.IdSolicitud}&idAlmacen=${customState.IdAlmacen}`
			)

			if (response?.status === 200) {
				const data = response.data

				setWharehouse({
					Id: data.almacen.idAlmacen,
					Name: data.almacen.almacen
				})

				setRequest({
					IdSolicitud: data.solicitud.idSolicitud,
					IdDocumento: data.solicitud.idDocumento,
					IdEstado: data.solicitud.idEstado,
					Estado: data.solicitud.estado,
					Numero: data.solicitud.numero,
					IdCentro: data.solicitud.idCentroCosto,
					Centro: data.solicitud.centroCosto,
					Fecha: moment(new Date(data.solicitud.fechaAprobacion))
						.locale('es')
						.format('dddd D [de] MMMM, YYYY')
				})

				setTitle(`Solicitud de Materiales ${data.solicitud.numero}`)

				const itemsList = data.articulos.map(i => {
					const fechaRegistro = moment(new Date(i.fechaRegistro)).format(
						'MM/DD/YYYY'
					)

					const fechaVencimiento =
						i.fechaVencimiento !== null
							? moment(new Date(i.fechaVencimiento)).format('MM/DD/YYYY')
							: 'No definido'

					return {
						key: i.idInventario.toString(),
						title: i.codigo,
						item: i.idArticulo,
						description: `(${fechaRegistro} | ${fechaVencimiento})`
					}
				})

				setData(
					data.detalles.map(d => {
						const amountToDispatch =
							d.cantidadRequerida >= d.existencias
								? d.existencias
								: d.cantidadRequerida
						return {
							...d,
							despachar: amountToDispatch,
							total: amountToDispatch * d.costo,
							articulos: itemsList
								.filter(i => i.item === d.idArticulo)
								.map(i => {
									return i.key
								})
								.slice(0, amountToDispatch)
						}
					})
				)

				setItems(itemsList)
			}
		} catch (error) {
			console.log(error)
		}
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
						onClick={() =>
							navigateToPath('/wharehouse', { Id: wharehouse?.Id })
						}
					>
						<span className='breadcrumb-item'>{wharehouse?.Name}</span>
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

	const dispatchItems = () => {
		const model = createWharehouseRequestDispatchModel()
		model.IdSolicitud = customState.IdSolicitud
		model.IdAlmacen = customState.IdAlmacen
		const itemsToDispatch = []
		data
			.filter(i => i.despachar > 0)
			.forEach(i => {
				i.articulos.forEach(e => {
					const item = Number(e)
					itemsToDispatch.push(item)
				})
			})
		model.Detalles = itemsToDispatch
		model.Total = total

		setLoading(true)
		saveRequestDispatch(model)
	}

	const saveRequestDispatch = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_REQUEST_DISPATCH, model)
			if (response?.status === 200) {
				openMessage('success', 'Despacho realizado', 6)
				navigateToPath('/wharehouse', { Id: wharehouse?.Id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setLoading(true)
		}
	}

	useEffect(() => {
		setTotal(data.reduce((t, d) => t + d.total, 0))
	}, [data])

	useEffect(() => {
		if (
			Object.keys(initialValuesModal).length !== 0 &&
			modalSource.length > 0
		) {
			handleRequestDispatchModelStatus()
			setLoadings(prevState => ({
				...prevState,
				[initialValuesModal.id]: false
			}))
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValuesModal, modalSource])

	useEffect(() => {
		if (
			Object.keys(wharehouse).length !== 0 &&
			Object.keys(request).length !== 0 &&
			!isStringEmpty(title)
		) {
			pageRenderer()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [wharehouse, request, title, data])

	useEffect(() => {
		const { state } = location
		setCustomState(state)

		document.title = 'Solicitud Materiales - Despacho'
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
			loadRequestDispatchDetails()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

	const descriptionItems = [
		{
			key: '1',
			label: 'Código',
			children: <span style={{ fontWeight: 'bold' }}>{request?.Numero}</span>
		},
		{
			key: '2',
			label: 'Centro Costo',
			children: <span style={{ fontWeight: 'bold' }}>{request?.Centro}</span>
		},
		{
			key: '3',
			label: 'Fecha Aprobación',
			children: <span>{request?.Fecha}</span>
		}
	]

	const columns = [
		{
			title: '',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Tooltip title='Seleccionar artículos'>
						<Button
							type='text'
							icon={<ReconciliationOutlined />}
							onClick={() => handleSpecificItemsSelection(record)}
							loading={loadings[record.key]}
							disabled={record.existencias <= 1}
						/>
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Artículo',
			dataIndex: '',
			key: 'articulo',
			render: (_, record) => (
				<span
					style={{ fontWeight: 'bold' }}
				>{`${record.codigo} | ${record.articuloCompleto}`}</span>
			)
		},
		// {
		// 	title: 'Familia',
		// 	dataIndex: 'familia',
		// 	key: 'familia',
		// 	width: 180,
		// 	render: text => <Tag>{text}</Tag>
		// },
		{
			title: 'Cantidad Requerida',
			dataIndex: 'cantidadRequerida',
			key: 'cantidadRequerida'
		},
		{
			title: 'Existencias',
			dataIndex: 'existencias',
			key: 'existencias'
		},
		{
			title: 'Despachar',
			dataIndex: 'despachar',
			key: 'despachar',
			render: (value, record) => (
				<span style={{ display: 'flex', justifyContent: 'center' }}>
					<InputNumber
						value={value}
						min={0}
						max={record.existencias}
						onChange={value => handleChange(value, record.key, 'despachar')}
					/>
				</span>
			)
		},
		{
			title: 'Costo RD$ (Unidad)',
			dataIndex: 'costo',
			key: 'costo',
			render: text => (
				<div style={{ textAlign: 'end' }}>
					<span>{addThousandsSeparators(text)}</span>
				</div>
			)
		},
		{
			title: 'Total RD$',
			dataIndex: 'total',
			key: 'total',
			render: text => (
				<div style={{ textAlign: 'end' }}>
					<span>{addThousandsSeparators(text)}</span>
				</div>
			)
		}
	]

	return (
		<>
			<RequestDispatchModel
				initialValues={initialValuesModal}
				source={modalSource}
				open={requestDispatchModalStatus}
				toggle={handleRequestDispatchModelStatus}
				saveData={saveItemData}
			/>
			<div className='page-content-container'>
				<div className='content-header'>
					<div style={{ display: 'flex', flexDirection: 'row' }}>
						<span className='title'>{title}</span>
					</div>
					<div>
						<Popconfirm
							title='Confirmar despacho'
							description='¿Seguro que desea despachar estos materiales?'
							onConfirm={dispatchItems}
							okText='Sí'
							cancelText='No'
						>
							<Button
								type='primary'
								icon={<SendOutlined />}
								loading={loading}
								disabled={total === 0}
							>
								Despachar
							</Button>
						</Popconfirm>
					</div>
				</div>
				<div className='body-container'>
					<Descriptions
						title='Detalles de la solicitud'
						bordered
						items={descriptionItems}
					/>
					<br />
					<Table
						columns={columns}
						dataSource={data}
						pagination={{
							pageSize: 10,
							current: currentPage,
							onChange: page => setCurrentPage(page)
						}}
						rowKey='key'
						locale={{
							emptyText: customNoDataText
						}}
						summary={() => (
							<Table.Summary>
								<Table.Summary.Row>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell></Table.Summary.Cell>
									<Table.Summary.Cell>
										<div style={{ fontWeight: 'bold', textAlign: 'end' }}>
											<span>{addThousandsSeparators(total)}</span>
										</div>
									</Table.Summary.Cell>
								</Table.Summary.Row>
							</Table.Summary>
						)}
					/>
				</div>
			</div>
		</>
	)
}

export default RequestDispatch
