import {
	AuditOutlined,
	EditOutlined,
	MoneyCollectOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Col, Row, Space, Statistic } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCostCenterModel } from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CostsCentersForm from './CostsCentersForm'
import CustomSimpleTable from './CustomSimpleTable'

const CENTROS_COSTOS_URL = '/api/centrosCostos/getCostsCentersData'
const CENTRO_COSTO_GET = '/api/centrosCostos/getCentroCostos'

const CostsCenters = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [costsCenters, setCostsCenters] = useState([])
	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

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
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			filterType: 'text search'
		},
		{
			title: 'Cuenta',
			dataIndex: 'cuenta',
			key: 'cuenta',
			filterType: 'text search'
		},
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
		},
		{
			title: 'Acciones',
			key: 'action',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						loading={loading[record.id]}
						onClick={() => handleEditCostCenter(record.id)}
					>
						Editar
					</Button>
					<Button icon={<AuditOutlined />} onClick={() => {}}>
						Historial
					</Button>
				</Space>
			)
		}
	]

	useEffect(() => {
		document.title = 'Centros de costos'
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
						<a onClick={() => navigate('/costsCenters')}>
							<span className='breadcrumb-item'>
								<MoneyCollectOutlined />
								<span className='breadcrumb-item-title'>Centros de costos</span>
							</span>
						</a>
					)
				}
			]

			handleBreadcrumb(breadcrumbItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return (
		<>
			<div className='page-content-container'>
				<CostsCentersForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
				/>
				<div className='info-container'>
					<Row align='end'>
						<Col span={3}>
							<Statistic
								style={{
									textAlign: 'end'
								}}
								title='Centros de costos'
								value={costsCenters.length}
							/>
						</Col>
					</Row>
				</div>
				<div className='btn-container'>
					<div className='right'>
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
					<CustomSimpleTable
						tableKey={tableKey}
						tableRef={tableRef}
						tableState={tableState}
						data={costsCenters}
						columns={columns}
					/>
				</div>
			</div>
		</>
	)
}

export default CostsCenters
