import {
	EditOutlined,
	EyeOutlined,
	FileAddOutlined,
	HomeOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Tag, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { userHasAccessToModule } from '../functions/validation'
import useCostCenters from '../hooks/useCostCenters'
import useDocumentStates from '../hooks/useDocumentStates'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const MODULE = 'Solicitudes de materiales'

const GET_REQUESTS_LIST = 'api/solicitudes/getSolicitudes'

const Requests = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()

	const [requests, setRequests] = useState([])
	const [loading, setLoading] = useState({})

	const documentoEstados = useDocumentStates()
	const centrosCostos = useCostCenters()

	const handleEditRequest = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		navigateToPath('/request', { Id: rowId })
	}

	const getRequestsList = async () => {
		try {
			const response = await axiosPrivate.get(GET_REQUESTS_LIST)

			if (response?.status === 200) {
				const data = response.data
				setRequests(data)
				setTableState(false)
			}
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Solicitudes'
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
						<span className='breadcrumb-item'>Solicitudes</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getRequestsList()
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
			width: 60,
			key: 'action',
			fixed: 'left',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Tooltip
						title={
							userHasAccessToModule(MODULE, 'view', roles) ||
							record.estado === 'Aprobado'
								? 'Ver'
								: 'Editar'
						}
					>
						<Button
							icon={
								userHasAccessToModule(MODULE, 'view', roles) ||
								record.estado === 'Aprobado' ? (
									<EyeOutlined />
								) : (
									<EditOutlined />
								)
							}
							type='text'
							onClick={() => handleEditRequest(record.key)}
							loading={loading[record.key]}
						/>
					</Tooltip>
				</Space>
			)
		},
		{
			title: 'Número',
			dataIndex: 'numero',
			key: 'numero',
			width: 100,
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Centro de costos',
			width: 200,
			dataIndex: 'centroCosto',
			key: 'centroCosto',
			filterType: 'custom filter',
			data: centrosCostos
		},
		{
			title: 'Fecha',
			dataIndex: 'fecha',
			key: 'fecha',
			width: 120,
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Estado',
			width: 150,
			dataIndex: 'estado',
			key: 'estado',
			filterType: 'custom filter',
			data: documentoEstados,
			render: state => (
				<>
					{
						<Tag
							color={
								state === 'Borrador'
									? 'geekblue'
									: state === 'En proceso'
									? 'yellow'
									: state === 'Aprobado'
									? 'green'
									: 'volcano'
							}
							key={state}
						>
							{state.toUpperCase()}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Justificación',
			dataIndex: 'justificacion',
			key: 'justificacion',
			width: 300,
			filterType: 'text search'
		},
		{
			title: 'Creado por',
			// dataIndex: 'creadoPor',
			width: 100,
			key: 'creadoPor',
			filterType: 'text search',
			render: (_, record) => (
				<Tooltip title={record.nombreCompleto}>
					<a style={{ color: '#2f54eb' }}>{record.creadoPor}</a>
				</Tooltip>
			)
		}
	]

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						{userHasAccessToModule(MODULE, 'creation', roles) ||
						userHasAccessToModule(MODULE, 'management', roles) ? (
							<Button
								type='primary'
								icon={<FileAddOutlined />}
								onClick={() => navigateToPath('/request', { Id: 0 })}
							>
								Nueva solicitud
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
						data={requests}
						columns={columns}
						scrollable={true}
					/>
				</div>
			</div>
		</>
	)
}

export default Requests
