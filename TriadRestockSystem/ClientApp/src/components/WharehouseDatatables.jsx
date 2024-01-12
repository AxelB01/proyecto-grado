import {
	AuditOutlined,
	DeleteOutlined,
	EditOutlined,
	EyeOutlined,
	FolderOutlined,
	PlusOutlined,
	ReconciliationOutlined
} from '@ant-design/icons'
import { Button, Popconfirm, Space, Tabs, Tag, Tooltip } from 'antd'
import 'moment/locale/es'
import moment from 'moment/moment'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createRequisitionsModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import CustomTable from './CustomTable'
import RequisitionEditModal from './RequisitionEditModal'

const APPROVE_REQUISICION = '/api/requisiciones/aprobarRequisicion'
const DISCARD_REQUISICION = '/api/requisiciones/descartarRequisicion'
const ARCHIVE_REQUISICION = '/api/requisiciones/archivarRequisicion'

const WharehouseDatatables = ({
	id,
	loading,
	requisitions,
	purchaseOrders,
	requests,
	items,
	itemsSorting,
	reloadWharehouse
}) => {
	const { roles } = useContext(AuthContext)
	const { openMessage, navigateToPath } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const [ordersTableKey] = useState(Date.now())
	const [ordersTableState] = useState(false)
	const ordersTableRef = useRef()

	const [requestsTableKey] = useState(Date.now())
	const [requestsTableState] = useState(false)
	const requestsTableRef = useRef()

	const [requisitionsTableKey] = useState(Date.now())
	const [requisitionsTableState] = useState(false)
	const requisitionsTableRef = useRef()

	const [requisitionsLoadings, setRequisitionsLoadings] = useState({})

	const [requisitionModalStatus, setRequisitionModalStatus] = useState(false)
	const [requisitionModalValues, setRequisitionModalValues] = useState({})

	const handleRequisitionModalStatus = () => {
		const status = !requisitionModalStatus
		setRequisitionModalStatus(status)
		if (!status) {
			setRequisitionModalValues({})
		}
	}

	const handlePendingOrderRegistration = model => {
		navigateToPath('/wharehousePurchaseOrderRegistration', {
			Id: model.key
		})
	}

	const handleRequestDispatch = idSolicitud => {
		navigateToPath('/requestDispatch', {
			IdSolicitud: idSolicitud,
			IdAlmacen: id
		})
	}

	const pendingColumnsOrders = [
		{
			title: '',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Tooltip title={record.idEstado === 4 ? 'Registrar' : 'Ver'}>
						<Button
							type='text'
							icon={
								record.idEstado === 4 ? (
									<ReconciliationOutlined />
								) : (
									<EyeOutlined />
								)
							}
							onClick={() => handlePendingOrderRegistration(record)}
							disabled={
								!userHasAccessToModule('Almacenes', 'view', roles) &&
								!userHasAccessToModule('Almacenes', 'creation', roles) &&
								!userHasAccessToModule('Almacenes', 'management', roles)
							}
						/>
					</Tooltip>
					<Popconfirm
						title='Archivar orden'
						description='¿Desea archivar esta orden?'
						okText='Sí'
						cancelText='Cancelar'
						onConfirm={() => console.log(record)}
					>
						<Button
							type='text'
							icon={<FolderOutlined />}
							loading={requisitionsLoadings[record.key]}
							disabled={
								record.idEstado !== 1 ||
								!userHasAccessToModule('Almacenes', 'management', roles)
							}
						/>
					</Popconfirm>
				</Space>
			)
		},
		{
			title: 'Codigo',
			dataIndex: 'numero',
			key: 'codigo',
			width: 90
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 110,
			render: (_, record) => (
				<Tag color={record.idEstado === 4 ? 'geekblue' : ''}>
					{record.estado}
				</Tag>
			)
		},
		{
			title: 'Proveedor',
			dataIndex: 'proveedor',
			key: 'proveedor',
			width: 250,
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha Estimada',
			dataIndex: 'fechaEntregaEstimada',
			key: 'fecha',
			width: 250,
			render: (_, record) =>
				`${moment(new Date(record.fechaEntregaEstimada))
					.locale('es')
					.format('dddd D [de] MMMM, YYYY')}`
		}
	]

	const pendingColumnsRequests = [
		{
			title: '',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Tooltip title=''>
						<Button
							type='text'
							icon={<AuditOutlined />}
							onClick={() => handleRequestDispatch(record.key)}
						/>
					</Tooltip>
					<Popconfirm
						title='Archivar solicitud'
						description='¿Desea archivar esta solicitud?'
						okText='Sí'
						cancelText='Cancelar'
						onConfirm={() => console.log(record)}
					>
						<Button
							type='text'
							icon={<FolderOutlined />}
							loading={requisitionsLoadings[record.key]}
							disabled={
								record.idEstado !== 1 ||
								!userHasAccessToModule('Almacenes', 'management', roles)
							}
						/>
					</Popconfirm>
				</Space>
			)
		},
		{
			title: 'Codigo',
			dataIndex: 'numero',
			key: 'codigo',
			width: 90
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 110,
			render: (_, record) => (
				<Tag color={record.idEstado === 4 ? 'geekblue' : ''}>
					{record.estado}
				</Tag>
			)
		},
		{
			title: 'Centro de costos',
			dataIndex: 'centroCosto',
			key: 'centroCostos',
			width: 250,
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha',
			dataIndex: 'fechaAprobacion',
			key: 'fecha',
			width: 250,
			render: (_, record) =>
				`${moment(new Date(record.fechaAprobacion))
					.locale('es')
					.format('dddd D [de] MMMM, YYYY')}`
		}
	]

	const pendingColumnsRequisitions = [
		{
			title: '',
			dataIndex: 'accion',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Tooltip title={record.idEstado === 1 ? 'Editar' : 'Ver'}>
						<Button
							type='text'
							icon={record.idEstado === 1 ? <EditOutlined /> : <EyeOutlined />}
							onClick={() => loadRequisitionData(record)}
							disabled={
								!userHasAccessToModule('Almacenes', 'view', roles) &&
								!userHasAccessToModule('Almacenes', 'creation', roles) &&
								!userHasAccessToModule('Almacenes', 'management', roles)
							}
						/>
					</Tooltip>
					<Popconfirm
						title='Aprobar requisición'
						description='¿Desea aprobar esta requisición?'
						okText='Sí'
						cancelText='Cancelar'
						onConfirm={() => handleApproveRequisition(record.key)}
					>
						<Button
							type='text'
							icon={<AuditOutlined />}
							loading={requisitionsLoadings[record.key]}
							disabled={
								record.idEstado !== 1 ||
								!userHasAccessToModule('Almacenes', 'management', roles)
							}
						/>
					</Popconfirm>
					{record.idEstado === 1 ? (
						<Popconfirm
							title='Descartar requisición'
							description='¿Desea descartar esta requisición?'
							okText='Sí'
							cancelText='Cancelar'
							onConfirm={() => handleDiscardRequisition(record.key)}
						>
							<Button
								type='text'
								icon={<DeleteOutlined />}
								loading={requisitionsLoadings[record.key]}
							/>
						</Popconfirm>
					) : null}
				</Space>
			)
		},
		{
			title: 'Codigo',
			dataIndex: 'numero',
			key: 'numero',
			width: 90
		},
		{
			title: 'Estado',
			key: 'estado',
			width: 140,
			render: record => (
				<Tag color={record.idEstado === 1 ? 'gold' : 'geekblue'}>
					{record.estado}
				</Tag>
			)
		},
		{
			title: 'Fecha',
			dataIndex: 'fechaFormateada',
			key: 'fechaFormateada',
			width: 350
		}
	]

	const newRequisition = () => {
		const model = createRequisitionsModel()
		model.IdAlmacen = id

		setRequisitionModalValues(model)
	}

	const loadRequisitionData = record => {
		const model = createRequisitionsModel()
		model.IdAlmacen = id
		model.Key = record.key
		model.IdRequisicion = record.key
		model.Numero = record.numero
		model.IdEstado = record.idEstado
		model.Estado = record.estado
		model.Fecha = record.fechaFormateada
		model.Articulos = record.articulos.map(a => {
			return {
				Articulo: a.idArticulo,
				Cantidad: a.cantidad
			}
		})

		setRequisitionModalValues(model)
	}

	const handleApproveRequisition = id => {
		setRequisitionsLoadings(prevState => ({
			...prevState,
			[id]: true
		}))
		approveRequisition(id)
	}

	const approveRequisition = async id => {
		try {
			const response = await axiosPrivate.post(APPROVE_REQUISICION, id)
			if (response?.status === 200) {
				openMessage('success', 'Requisición aprobada')
			} else openMessage('error', 'Ha ocurrido un error inesperado...')
		} catch (error) {
			console.log(error)
			openMessage('error', 'Ha ocurrido un error inesperado...')
		} finally {
			setRequisitionsLoadings(prevState => ({
				...prevState,
				[id]: false
			}))
			setTimeout(() => {
				reloadWharehouse()
			}, 100)
		}
	}

	const handleDiscardRequisition = id => {
		setRequisitionsLoadings(prevState => ({
			...prevState,
			[id]: true
		}))
		discardRequisition(id)
	}

	const discardRequisition = async id => {
		try {
			const response = await axiosPrivate.post(DISCARD_REQUISICION, id)
			if (response?.status === 200) {
				openMessage('info', 'Requisición descartada')
			} else openMessage('error', 'Ha ocurrido un error inesperado...')
		} catch (error) {
			console.log(error)
			openMessage('error', 'Ha ocurrido un error inesperado...')
		} finally {
			setRequisitionsLoadings(prevState => ({
				...prevState,
				[id]: false
			}))
			setTimeout(() => {
				reloadWharehouse()
			}, 100)
		}
	}

	const tabItems = [
		{
			key: '1',
			label: 'Requisiciones',
			children: (
				<>
					{userHasAccessToModule('Almacenes', 'view', roles) ||
					userHasAccessToModule('Almacenes', 'creation', roles) ||
					userHasAccessToModule('Almacenes', 'management', roles) ? (
						<>
							<Button
								type='primary'
								icon={<PlusOutlined />}
								onClick={newRequisition}
							>
								Nueva requisición manual
							</Button>
							<br />
						</>
					) : null}
					<CustomTable
						tableKey={requisitionsTableKey}
						tableRef={requisitionsTableRef}
						tableState={requisitionsTableState || loading}
						tableClases='custom-table-style no-hover'
						columns={pendingColumnsRequisitions}
						data={requisitions}
						defaultPageSize={5}
						scrollable={false}
					/>
				</>
			)
		},
		{
			key: '2',
			label: 'Órdenes de compra',
			children: (
				<CustomTable
					tableKey={ordersTableKey}
					tableRef={ordersTableRef}
					tableState={ordersTableState || loading}
					tableClases='custom-table-style no-hover'
					columns={pendingColumnsOrders}
					data={purchaseOrders}
					defaultPageSize={5}
					scrollable={false}
				/>
			)
		},
		{
			key: '3',
			label: 'Solicitudes de materiales',
			children: (
				<CustomTable
					tableKey={requestsTableKey}
					tableRef={requestsTableRef}
					tableState={requestsTableState || loading}
					tableClases='custom-table-style no-hover'
					columns={pendingColumnsRequests}
					data={requests}
					defaultPageSize={5}
					scrollable={false}
				/>
			)
		}
	]

	useEffect(() => {
		if (Object.keys(requisitionModalValues).length !== 0) {
			handleRequisitionModalStatus()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [requisitionModalValues])

	useEffect(() => {
		const requisitionsLoadingValues = Object.values(requisitionsLoadings)
		const noRequisitionsLoading = requisitionsLoadingValues.every(
			r => r !== true
		)

		if (!requisitionModalStatus && noRequisitionsLoading) {
			reloadWharehouse()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [requisitionModalStatus])

	return (
		<>
			<RequisitionEditModal
				open={requisitionModalStatus}
				toggle={handleRequisitionModalStatus}
				approveRequisition={handleApproveRequisition}
				items={items}
				itemsSorting={itemsSorting}
				initialValues={requisitionModalValues}
			/>
			<Tabs defaultActiveKey='1' items={tabItems} />
		</>
	)
}

export default WharehouseDatatables
