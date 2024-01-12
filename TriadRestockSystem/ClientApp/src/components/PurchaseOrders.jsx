import {
	EditOutlined,
	HomeOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Tag, Tooltip } from 'antd'
import 'moment/locale/es'
import moment from 'moment/moment'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createPurchaseOrderFormModel } from '../functions/constructors'
import { addThousandsSeparators } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const PURCHASE_ORDERS_DATA_URL = '/api/ordenescompra/getOrdenesCompra'

const PurchaseOrders = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [loading, setLoading] = useState({})

	const [wharehouses, setWharehouse] = useState([])
	const [suppliers, setSuppliers] = useState([])
	const [paymentTypes, setPaymentTypes] = useState([])
	const [documentStates, setDocumentStates] = useState([])

	const [tableState, setTableState] = useState(true)
	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())

	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				console.log(column)
				column.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const handlePurchaseOrderLoad = id => {
		setLoading(prevState => ({
			...prevState,
			[id]: true
		}))
		const record = data.find(x => x.idOrden === id)
		goToPurchaseOrder(record)
	}

	const goToPurchaseOrder = record => {
		const model = createPurchaseOrderFormModel()
		model.IdOrden = record.idOrden
		model.Numero = record.numero
		model.IdRequisicion = record.idRequisicion
		model.IdAlmacen = record.idAlmacen
		model.IdEstado = record.idEstado
		model.Estado = record.estado
		model.IdProveedor = record.idProveedor
		model.TipoPago = record.tipoPago
		model.FechaEstimada = record.fechaEstimada
		model.Notas = record.notas
		model.ArticulosDetalles = record.articulosDetalles.map(item => {
			return {
				IdArticulo: item.idArticulo,
				Cantidad: item.cantidad,
				IdImpuesto: item.idImpuesto,
				Impuesto: item.impuesto,
				ImpuestoDecimal: item.impuestoDecimal,
				PrecioBase: item.precioBase
			}
		})
		model.PagoDetalles = record.pagoDetalles.map(item => {
			return {
				Descripcion: item.descripcion,
				Tasa: item.tasa,
				Tipo: item.tipo,
				Valor: item.valor
			}
		})

		setLoading(prevState => ({
			...prevState,
			[record.idOrden]: false
		}))
		navigateToPath('/purchaseOrder', model)
	}

	useEffect(() => {
		document.title = 'Órdenes de Compra'
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
					<a onClick={() => {}}>
						<span className='breadcrumb-item'>Órdenes de Compra</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)
			} else {
				handleLayout(false)
			}
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin])

	useEffect(() => {
		const interval = setInterval(() => {
			if (display) {
				handleLayoutLoading(false)
			}
		}, 200)
		return () => {
			clearInterval(interval)
		}
	}, [display, handleLayoutLoading])

	useEffect(() => {
		if (!validLogin) {
			navigateToPath('/login')
		} else {
			getPurchaseOrdersData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin, roles, navigateToPath])

	const columns = [
		{
			title: '',
			key: 'actions',
			fixed: 'left',
			width: 60,
			render: (_, record) => (
				<Space align='center'>
					<Tooltip title='Editar'>
						<Button
							type='text'
							icon={<EditOutlined />}
							loading={loading[record.idOrden]}
							onClick={() => handlePurchaseOrderLoad(record.idOrden)}
						/>
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Código',
			dataIndex: 'numero',
			key: 'numero',
			fixed: 'left',
			width: 130,
			filterType: 'text search'
		},
		{
			title: 'Estado',
			dataIndex: 'idEstado',
			key: 'estado',
			width: 100,
			render: id => (
				<Tag>{`${documentStates.find(x => x.key === id)?.estado}`}</Tag>
			)
		},
		{
			title: 'Alamacen',
			key: 'almacen',
			filterType: 'text search',
			width: 250,
			render: (_, record) =>
				`${wharehouses.find(x => x.key === record.idAlmacen)?.almacen}`
		},
		{
			title: 'Proveedor',
			key: 'proveedor',
			filterType: 'text search',
			width: 250,
			render: (_, record) =>
				`${suppliers.find(x => x.key === record.idProveedor)?.proveedor}`
		},
		{
			title: 'Total A Pagar (RD$)',
			dataIndex: 'totalAPagar',
			key: 'totalAPagar',
			width: 200,
			filterType: 'text search',
			render: text => (
				<div style={{ textAlign: 'end' }}>
					<span>RD$ {`${addThousandsSeparators(text)}`}</span>
				</div>
			)
		},
		{
			title: 'Tipo de pago',
			dataIndex: 'tipoPago',
			key: 'tipoPago',
			width: 150,
			render: (_, record) => (
				<Tag>{paymentTypes.find(x => x.key === record.tipoPago)?.tipoPago}</Tag>
			)
		},
		{
			title: 'Fecha Estimada Entrega',
			key: 'fechaEstimada',
			width: 280,
			render: (_, record) =>
				`${moment(new Date(record.fechaEstimada))
					.locale('es')
					.format('dddd D [de] MMMM, YYYY')}`
		},
		{
			title: 'Fecha Entrega',
			key: 'fechaEntrega',
			width: 280,
			render: (_, record) =>
				record.fechaEntrega ? 'Disponible' : 'No disponible'
		}
	]

	const getPurchaseOrdersData = async () => {
		try {
			const response = await axiosPrivate.get(PURCHASE_ORDERS_DATA_URL)
			const data = response?.data
			console.log(data)
			setData(data.ordenesCompra)
			setWharehouse(data.almacenes)
			setSuppliers(data.proveedores)
			setPaymentTypes(data.tiposPagos)
			setDocumentStates(data.estadosDocumentos)
			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

	const goToNewPurchaseOrder = () => {
		const model = createPurchaseOrderFormModel()
		navigateToPath('/purchaseOrder', model)
	}

	return (
		<>
			<div className='btn-container'>
				<div className='right'>
					<Button
						type='primary'
						icon={<PlusOutlined />}
						onClick={goToNewPurchaseOrder}
					>
						Nueva orden de compra
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
			</div>

			<div className='table-container'>
				<CustomTable
					tableKey={tableKey}
					tableRef={tableRef}
					tableState={tableState}
					data={data}
					columns={columns}
					scrollable={true}
					defaultPageSize={10}
				/>
			</div>
		</>
	)
}
export default PurchaseOrders
