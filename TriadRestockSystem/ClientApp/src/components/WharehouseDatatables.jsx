import {
	AuditOutlined,
	EditOutlined,
	FolderOutlined,
	PlusOutlined
} from '@ant-design/icons'
import { Button, Space, Tabs, Tag, Tooltip } from 'antd'
import { useEffect, useRef, useState } from 'react'
import { createWharehouseRequisitionModel } from '../functions/constructors'
import CustomTable from './CustomTable'
import RequisitionEditModal from './RequisitionEditModal'

const WharehouseDatatables = ({ id, loading, requisitions, items }) => {
	const [ordersTableKey] = useState(Date.now())
	const [ordersTableState] = useState(false)
	const ordersTableRef = useRef()

	const [requestsTableKey] = useState(Date.now())
	const [requestsTableState] = useState(false)
	const requestsTableRef = useRef()

	const [requisitionsTableKey] = useState(Date.now())
	const [requisitionsTableState] = useState(false)
	const requisitionsTableRef = useRef()

	const [requisitionModalStatus, setRequisitionModalStatus] = useState(false)
	const [requisitionModalValues, setRequisitionModalValues] = useState({})

	const handleRequisitionModalStatus = () => {
		const status = !requisitionModalStatus
		setRequisitionModalStatus(status)
		if (!status) {
			setRequisitionModalValues({})
		}
	}

	const pendingColumnsOrders = [
		{
			title: 'Codigo',
			dataIndex: 'codigo',
			key: 'codigo',
			width: 90
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 110
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

	const pendingColumnsRequests = [
		{
			title: 'Codigo',
			dataIndex: 'codigo',
			key: 'codigo',
			width: 90
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 110
		},
		{
			title: 'Centro de costos',
			dataIndex: 'centroCostos',
			key: 'centroCostos',
			width: 330,
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha',
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

	const pendingColumnsRequisitions = [
		{
			title: '',
			dataIndex: 'accion',
			key: 'accion',
			render: (_, record) => (
				<Space>
					<Tooltip title='Editar'>
						<Button
							type='text'
							icon={<EditOutlined />}
							onClick={() => loadRequisitionData(record)}
						/>
					</Tooltip>
					<Tooltip title='Aprobar'>
						<Button type='text' icon={<AuditOutlined />} disabled />
					</Tooltip>
					<Tooltip title='Archivar'>
						<Button type='text' icon={<FolderOutlined />} disabled />
					</Tooltip>
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
				<Tag color={record.idEstado === 1 ? 'gold' : ''}>{record.estado}</Tag>
			)
		},
		{
			title: 'Fecha',
			dataIndex: 'fechaFormateada',
			key: 'fechaFormateada',
			width: 240
		}
	]

	const loadRequisitionData = record => {
		const model = createWharehouseRequisitionModel()
		model.Id = record.key
		model.Numero = record.numero
		model.IdEstado = record.idEstado
		model.Estado = record.estado
		model.Fecha = record.fechaFormateada
		model.Detalles = record.articulos.map(a => {
			return {
				Articulo: a.idArticulo,
				Cantidad: a.cantidad
			}
		})
		setRequisitionModalValues(model)
	}

	const tabItems = [
		{
			key: '1',
			label: 'Requisiciones',
			children: (
				<>
					<Button type='primary' icon={<PlusOutlined />} disabled>
						Nueva requisición manual
					</Button>
					<br />
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
					data={[]}
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
					data={[]}
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

	return (
		<>
			<RequisitionEditModal
				open={requisitionModalStatus}
				toggle={handleRequisitionModalStatus}
				items={items}
				initialValues={requisitionModalValues}
			/>
			<Tabs defaultActiveKey='1' items={tabItems} />
		</>
	)
}

export default WharehouseDatatables
