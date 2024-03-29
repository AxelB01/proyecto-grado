import {
	AuditOutlined,
	EditOutlined,
	HomeOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCostCenterModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useBankAccounts from '../hooks/useBankAccounts'
import useBanks from '../hooks/useBanks'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CostsCentersForm from './CostsCentersForm'
import CustomTable from './CustomTable'

const MODULE = 'Centros de costos'

const CENTROS_COSTOS_URL = '/api/configuraciones/getCostsCentersData'
const CENTRO_COSTO_GET = '/api/configuraciones/getCentroCostos'

const CostsCenters = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [costsCenters, setCostsCenters] = useState([])
	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

	const banks = useBanks().items
	const banksAccounts = useBankAccounts().items

	const [initialValues, setInitialValues] = useState(createCostCenterModel())

	const handleEditCostCenter = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getCostCenter(rowId)
	}

	const handleOpen = value => {
		setOpen(value)
		if (!value) {
			setInitialValues(createCostCenterModel())
		}
	}

	const handleLoading = value => {
		setFormLoading(value)
	}

	const getCostCenter = async id => {
		try {
			const response = await axiosPrivate.get(CENTRO_COSTO_GET + `?id=${id}`)
			const data = response?.data
			const model = createCostCenterModel()
			model.IdCentroCosto = data.idCentroCosto
			model.Nombre = data.nombre
			model.IdBanco = data.idBanco
			model.Cuenta = data.cuenta
			setInitialValues(model)
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		const getCostCenters = async () => {
			try {
				const response = await axiosPrivate.get(CENTROS_COSTOS_URL)
				setCostsCenters(response?.data)
				setTableState(false)
			} catch (error) {
				console.log(error)
			}
		}
		getCostCenters()
	}, [axiosPrivate, open])

	useEffect(() => {
		const { IdCentroCosto } = initialValues
		if (IdCentroCosto !== 0) {
			setOpen(true)
			setLoading(prevState => ({
				...prevState,
				[IdCentroCosto]: false
			}))
		}
	}, [initialValues])

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

	const columns = [
		{
			title: '',
			key: 'action',
			width: 80,
			render: (_, record) => (
				<Space size='middle' align='center'>
					{!userHasAccessToModule(MODULE, 'view', roles) ? (
						<Tooltip title='Editar'>
							<Button
								type='text'
								icon={<EditOutlined />}
								loading={loading[record.id]}
								onClick={() => handleEditCostCenter(record.id)}
							/>
						</Tooltip>
					) : null}
					<Tooltip title='Historial'>
						<Button type='text' icon={<AuditOutlined />} disabled />
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			width: 200,
			filterType: 'text search'
		},
		// {
		// 	title: 'Cuenta',
		// 	dataIndex: 'cuenta',
		// 	key: 'cuenta',
		// 	width: 200,
		// 	filterType: 'text search'
		// },
		// {
		// 	title: 'Descripción',
		// 	dataIndex: 'cuentaDescripcion',
		// 	key: 'cuentaDescripcion',
		// 	width: 500,
		// 	filterType: 'text search',
		// 	render: (_, record) => (
		// 		<span>{`${record.banco} | ${record.cuentaDescripcion}`}</span>
		// 	)
		// },
		{
			title: 'Creador',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		}
	]

	useEffect(() => {
		document.title = 'Centros de costos'
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
						<span className='breadcrumb-item'>Centros de costos</span>
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
		}
	}, [validLogin, roles, navigateToPath])

	return (
		<>
			<div className='page-content-container'>
				<CostsCentersForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
					banks={banks}
					bankAccounts={banksAccounts}
				/>
				<div className='info-container to-right'>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Centros de costos'
						value={costsCenters.length}
					/>
				</div>
				<div className='btn-container'>
					<div className='right'>
						{!userHasAccessToModule(MODULE, 'view', roles) ? (
							<Button
								style={{
									display: 'flex',
									alignItems: 'center'
								}}
								type='primary'
								icon={<PlusOutlined />}
								onClick={() => handleOpen(true)}
							>
								Nuevo Centro de costos
							</Button>
						) : null}
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
						data={costsCenters}
						columns={columns}
						scrollable={false}
					/>
				</div>
			</div>
		</>
	)
}

export default CostsCenters
