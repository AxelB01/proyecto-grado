import {
	EditOutlined,
	FileAddOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Button, Space, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useCostCenters from '../hooks/useCostCenters'
import useDocumentStates from '../hooks/useDocumentStates'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const GET_REQUESTS_LIST = 'api/solicitudes/getSolicitudes'

const Requests = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()

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
		navigate('/request', { state: rowId })
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
						<a onClick={() => navigate('/requests')}>
							<span className='breadcrumb-item'>
								{/* <SolutionOutlined /> */}
								<span className='breadcrumb-item-title'>Solicitudes</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
			getRequestsList()
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

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
			title: 'Número',
			dataIndex: 'numero',
			key: 'numero',
			width: 150,
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Centro de costos',
			dataIndex: 'centroCosto',
			key: 'centroCosto',
			fixed: 'left',
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
			title: 'Justificación',
			dataIndex: 'justificacion',
			key: 'justificacion',
			width: 500,
			filterType: 'text search'
		},
		{
			title: 'Estado',
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
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Acciones',
			key: 'accion',
			fixed: 'right',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						onClick={() => handleEditRequest(record.key)}
						loading={loading[record.key]}
					>
						{loading[record.key] ? 'Cargando' : 'Editar'}
					</Button>
				</Space>
			)
		}
	]

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						<Button
							type='primary'
							icon={<FileAddOutlined />}
							onClick={() => navigate('/request')}
						>
							Nueva solicitud
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
