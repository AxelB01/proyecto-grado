import { PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import { Avatar, Button, Progress, Space, Tag, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useWharehouseStates from '../hooks/useWharehouseStates'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const GET_WHAREHOUSES = 'api/almacenes/getAlmacenes'

const Wharehouses = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)

	const wharehouseStates = useWharehouseStates().items

	const [tableState, setTableState] = useState(true)
	// const [tableLoading, setTableLoading] = useState({})
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

	const getWharehouses = async () => {
		try {
			setLoading(true)
			const response = await axiosPrivate.get(GET_WHAREHOUSES)
			if (response?.status === 200) {
				const responseData = response.data
				setData(responseData)
				setTableState(false)
			}
		} catch (error) {
			console.log(error)
		} finally {
			setLoading(false)
		}
	}

	useEffect(() => {
		document.title = 'Almacenes'
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
						<a onClick={() => navigate('/wharehouses')}>
							<span className='breadcrumb-item'>
								{/* <SolutionOutlined /> */}
								<span className='breadcrumb-item-title'>Almacenes</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
			getWharehouses()
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	const columns = [
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			width: 300,
			filterType: 'text search'
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 150,
			filterType: 'custom filter',
			data: wharehouseStates,
			render: text => (
				<Space
					style={{
						width: '100%',
						display: 'flex',
						flexDirection: 'row',
						justifyContent: 'start'
					}}
				>
					<Tag color={text === 'Activo' ? 'geekblue' : 'volcano'}>{text}</Tag>
				</Space>
			)
		},
		{
			title: 'Personal',
			dataIndex: 'personal',
			key: 'personal',
			render: data => (
				<>
					<Avatar.Group maxCount={5}>
						{data.map(item => {
							return (
								<Tooltip
									key={item.idUsuario}
									title={`${item.nombre}, ${item.puesto}`}
								>
									<Avatar>{item.nombre[0]}</Avatar>
								</Tooltip>
							)
						})}
					</Avatar.Group>
				</>
			)
		},
		{
			title: 'Despachos',
			dataIndex: 'despachos',
			render: (_, record) => (
				<Tooltip title='3 Completadas / 3 En proceso / 6 Por hacer'>
					<Progress
						percent={60}
						success={{ percent: 30 }}
						status='active'
						size='small'
					/>
				</Tooltip>
			)
		},
		{
			title: '',
			dataIndex: 'accion',
			width: 80,
			render: (_, record) => (
				<Space
					size='middle'
					align='center'
					style={{
						width: '100%',
						display: 'flex',
						flexDirection: 'row',
						justifyContent: 'center'
					}}
				>
					<Button
						type='text'
						onClick={() => navigate('/wharehouse', { state: record.key })}
					>
						Entrar
					</Button>
				</Space>
			)
		}
	]

	const expandedRowRender = record => {
		return (
			<p
				style={{
					margin: 0
				}}
			>
				{record.descripcion}
			</p>
		)
	}

	return (
		<>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						<Button type='primary' icon={<PlusOutlined />} onClick={() => {}}>
							Nuevo Almacén
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
				<div className='content-container'>
					<CustomTable
						tableKey={tableKey}
						tableRef={tableRef}
						tableState={tableState}
						data={data}
						columns={columns}
						expandedRowRender={expandedRowRender}
						scrollable={false}
					/>
					{/* <List
						loading={loading}
						itemLayout='horizontal'
						dataSource={data}
						renderItem={item => (
							<List.Item actions={[]}>
								<Card
									hoverable
									style={{ width: '100%' }}
									title={item.nombre}
									extra={
										<Button key={item.key} type='primary'>
											Entrar
										</Button>
									}
								>
									<>
										<span style={{ fontWeight: 'w400', fontSize: '1.05em' }}>
											Descripción
										</span>
										<p>{item.descripcion}</p>
										<span style={{ fontWeight: 'bold', fontSize: '1.05em' }}>
											Ubicación
										</span>
										<p>{item.ubicacion}</p>
										<span style={{ fontWeight: 'bold', fontSize: '1.05em' }}>
											Espacio
										</span>
										<p>{`${item.espacio} m²`}</p>
									</>
								</Card>
							</List.Item>
						)}
					/> */}
				</div>
			</div>
		</>
	)
}

export default Wharehouses
