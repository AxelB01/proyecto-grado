import {
	AuditOutlined,
	FolderOutlined,
	HomeOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Tag, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { userHasAccessToModule } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import PurchaseOrderAutomaticForm from './PurchaseOrderAutomaticForm'

const REQUISITIONS_GET_ALL = '/api/requisiciones/getRequisiciones'

const Requisitions = () => {
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
	const [states, setStates] = useState([])
	const [wharehouses, setWharehouses] = useState([])

	const [tableState, setTableState] = useState(true)
	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())
	const [loadings, setLoadings] = useState({})

	const [
		purchaseOrderAutomaticFormStatus,
		setPurchaseOrderAutomaticFormStatus
	] = useState(false)
	const [
		purchaseOrderAutomaticFormValues,
		setPurchaseOrderAutomaticFormValues
	] = useState({})

	const handlePurchaseOrderAutomaticFormStatus = () => {
		setPurchaseOrderAutomaticFormStatus(!purchaseOrderAutomaticFormStatus)
		if (!purchaseOrderAutomaticFormStatus) {
			setPurchaseOrderAutomaticFormValues({})
		}
	}

	const handleFiltersReset = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				column.filteredValue = null
			})
		}

		setTableKey(Date.now())
	}

	const handleLoadRequisitionDataForPurchaseOrder = rowId => {
		setLoadings(prevState => ({
			...prevState,
			[rowId]: true
		}))
		const requisition = data.filter(r => r.key === rowId)[0]
		setPurchaseOrderAutomaticFormValues(requisition)
	}

	useEffect(() => {
		if (Object.keys(purchaseOrderAutomaticFormValues).length !== 0) {
			setLoadings(prevState => ({
				...prevState,
				[purchaseOrderAutomaticFormValues.key]: false
			}))
			handlePurchaseOrderAutomaticFormStatus()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [purchaseOrderAutomaticFormValues])

	useEffect(() => {
		document.title = 'Requisiciones'
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
						<span className='breadcrumb-item'>Requisiciones</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getRequisitionsData()
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
		}
	}, [validLogin, roles, navigateToPath])

	const columns = [
		{
			title: '',
			dataIndex: 'accion',
			key: 'accion',
			width: 40,
			render: (_, record) => (
				<Space>
					{/* <Tooltip title='Ver artículos'>
						<Button type='text' icon={<EyeOutlined />} onClick={() => {}} />
					</Tooltip> */}
					<Tooltip title='Generar orden'>
						<Button
							type='text'
							icon={<AuditOutlined />}
							loading={loadings[record.key]}
							onClick={() =>
								handleLoadRequisitionDataForPurchaseOrder(record.key)
							}
							disabled={
								!userHasAccessToModule('Requisiciones', 'creation', roles) &&
								!userHasAccessToModule('Requisiciones', 'management', roles)
							}
						/>
					</Tooltip>
					<Tooltip title='Archivar'>
						<Button type='text' icon={<FolderOutlined />} disabled />
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Código',
			dataIndex: 'idRequisicion',
			key: 'idRequisicion',
			width: 140,
			filterType: 'text search'
		},
		{
			title: 'Número',
			dataIndex: 'numero',
			key: 'numero',
			width: 140,
			filterType: 'text search'
		},
		{
			title: 'Almacén',
			dataIndex: 'almacen',
			key: 'almacen',
			width: 250,
			filterType: 'custom filter',
			data: wharehouses
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 150,
			filterType: 'custom filter',
			data: states,
			render: text => (
				<>
					{
						<Tag color={text === 'Aprobado' ? 'green' : 'volcano'} key={text}>
							{text.toUpperCase()}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Fecha Aprobación',
			dataIndex: 'fechaAprobacionFormateada',
			key: 'fechaAprobacion',
			width: 300,
			filterType: 'date sorter',
			dateFormat: 'dddd DD [de] MMMM, YYYY'
		},
		{
			title: 'Aprobado Por',
			key: 'aprobadoPor',
			filterType: 'text search',
			render: (_, record) => (
				<Tooltip title={record.usuario}>
					<a style={{ color: '#2f54eb', textDecoration: 'none' }}>
						{record.aprobadoPor}
					</a>
				</Tooltip>
			)
		},
		{
			title: 'Fecha Archivado',
			dataIndex: 'fechaArchivadoFormateada',
			key: 'fechaArchivado',
			width: 300,
			filterType: 'date sorter',
			dateFormat: 'dddd DD [de] MMMM, YYYY'
		},
		{
			title: 'Archivado Por',
			key: 'archivadoPor',
			filterType: 'text search',
			render: (_, record) => (
				<Tooltip title={record.usuario}>
					<a style={{ color: '#2f54eb', textDecoration: 'none' }}>
						{record.archivadoPor}
					</a>
				</Tooltip>
			)
		}
	]

	const getRequisitionsData = async () => {
		try {
			const response = await axiosPrivate.get(REQUISITIONS_GET_ALL)
			if (response?.status === 200) {
				const data = response.data

				console.log(data)

				setData(data.requisiciones)
				setStates(data.estados)
				setWharehouses(data.almacenes)
			}

			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<PurchaseOrderAutomaticForm
				status={purchaseOrderAutomaticFormStatus}
				toggle={handlePurchaseOrderAutomaticFormStatus}
				initialValues={purchaseOrderAutomaticFormValues}
			/>
			<div className='btn-container'>
				<div className='right'>
					{/* <Button type='primary' icon={<UserAddOutlined />}>
						Nueva Requisicion
					</Button> */}
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
					defaultPageSize={10}
				/>
			</div>
		</>
	)
}
export default Requisitions
