import {
	AuditOutlined,
	EditOutlined,
	MoneyCollectOutlined,
	PlusOutlined,
	ReloadOutlined,
	SearchOutlined
} from '@ant-design/icons'
import { Button, Empty, Input, Space, Table } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import moment from 'moment'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCostCenterModel } from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CostsCentersForm from './CostsCentersForm'

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

	// Custom Filter
	// const [searchText, setSearchText] = useState('')
	// const [searchColumn, setSearchedColumn] = useState('')
	const searchInput = useRef(null)
	const handleSearch = (selectedKeys, confirm, dataIndex) => {
		confirm()
		// setSearchText(selectedKeys[0])
		// setSearchedColumn(dataIndex)
	}

	const handleReset = (clearFilters, confirm, dataIndex) => {
		clearFilters()
		confirm()
		// setSearchText('')
		// setSearchedColumn(dataIndex)
	}

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

	const getColumnSearchProps = dataIndex => ({
		filterDropdown: ({
			setSelectedKeys,
			selectedKeys,
			confirm,
			clearFilters,
			close
		}) => (
			<div style={{ padding: 8 }} onKeyDown={e => e.stopPropagation()}>
				<Input
					ref={searchInput}
					placeholder={`Buscar por ${dataIndex}`}
					value={selectedKeys[0]}
					onChange={e =>
						setSelectedKeys(e.target.value ? [e.target.value] : [])
					}
					onPressEnter={() => handleSearch(selectedKeys, confirm, dataIndex)}
					style={{
						marginBottom: 8,
						display: 'block'
					}}
				/>
				<Space>
					<Button
						type='primary'
						onClick={() => handleSearch(selectedKeys, confirm, dataIndex)}
						icon={<SearchOutlined />}
						size='small'
						style={{
							width: 90
						}}
					>
						Buscar
					</Button>
					<Button
						onClick={() =>
							clearFilters && handleReset(clearFilters, confirm, dataIndex)
						}
						size='small'
						style={{
							width: 90
						}}
					>
						Limpiar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							confirm({
								closeDropdown: false
							})
							// setSearchText(selectedKeys[0])
							// setSearchedColumn(dataIndex)
						}}
					>
						Filtrar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							close()
						}}
					>
						Cerrar
					</Button>
				</Space>
			</div>
		),
		filterIcon: filtered => (
			<SearchOutlined style={{ color: filtered ? '#1677ff' : undefined }} />
		),
		onFilter: (value, record) =>
			record[dataIndex].toString().toLowerCase().includes(value.toLowerCase()),
		onFilterDropdownOpenChange: visible => {
			if (visible) {
				setTimeout(() => searchInput.current?.select(), 100)
			}
		}
		// render: text =>
		// 	searchColumn === dataIndex ? (
		// 		<Highlighter
		// 			highlightStyle={{
		// 				backgroundColor: '#ffc069',
		// 				padding: 0
		// 			}}
		// 			searchWords={[searchText]}
		// 			autoEscape
		// 			textToHighlight={text ? text.toString() : ''}
		// 		/>
		// 	) : (
		// 		text
		// 	)
	})

	// Custom Filter

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			...getColumnSearchProps('id')
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			...getColumnSearchProps('nombre')
		},
		{
			title: 'Cuenta',
			dataIndex: 'cuenta',
			key: 'cuenta',
			...getColumnSearchProps('cuenta')
		},
		{
			title: 'Creador',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			...getColumnSearchProps('creadoPor'),
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			sorter: (a, b) =>
				moment(a.fecha, 'DD/MM/YYYY').unix() -
				moment(b.fecha, 'DD/MM/YYYY').unix(),
			sortDirections: ['ascend', 'descend']
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

	const customNoDataText = (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)

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
				<div className='btn-container'>
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
				</div>
				<div className='table-container'>
					<Table
						key={tableKey}
						ref={tableRef}
						columns={columns}
						dataSource={costsCenters}
						pagination={{
							total: costsCenters.length,
							showTotal: () => `${costsCenters.length} registros en total`,
							defaultPageSize: 10,
							defaultCurrent: 1
						}}
						locale={{
							emptyText: customNoDataText
						}}
					/>
				</div>
			</div>
		</>
	)
}

export default CostsCenters
