import {
	ArrowRightOutlined,
	EditOutlined,
	HomeOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'
import { Avatar, Button, Space, Tag, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createWharehouesesModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useDataList from '../hooks/useDataList'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useWharehouseStates from '../hooks/useWharehouseStates'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import WharehouseForm from './WharehouseForm'

const MODULE = 'Almacenes'

const GET_WHAREHOUSES = 'api/almacenes/getAlmacenes'
const GET_WHAREHOUSES_STAFF = 'api/almacenes/almacenPersonal'

const Wharehouses = () => {
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
	const [loading, setLoading] = useState(false)

	const wharehouseStates = useWharehouseStates().items
	const estado = useWharehouseStates()
	const personal = useDataList(GET_WHAREHOUSES_STAFF)

	const [tableState, setTableState] = useState(true)
	// const [tableLoading, setTableLoading] = useState({})
	const tableRef = useRef()
	const [tableKey, setTableKey] = useState(Date.now())
	const [open, setOpen] = useState(false)
	const [title, setTitle] = useState('')

	const [wharehouseFormInitialValues, setWharehouseFormInitialValues] =
		useState({})

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

	const loadWharehouseData = id => {
		const wharehouseData = data.filter(d => d.key === id)[0]
		const model = createWharehouesesModel()
		model.IdAlmacen = wharehouseData.key
		model.Nombre = wharehouseData.nombre
		model.Descripcion = wharehouseData.descripcion
		model.Ubicacion = wharehouseData.ubicacion
		model.Espacio = wharehouseData.espacio
		model.IdsPersonal = wharehouseData.personal.map(p => {
			return p.idUsuario
		})
		model.IdEstado = wharehouseData.idEstado

		setWharehouseFormInitialValues(model)
	}

	useEffect(() => {
		if (Object.keys(wharehouseFormInitialValues).length !== 0) {
			setOpen(true)
		}
	}, [wharehouseFormInitialValues])

	useEffect(() => {
		if (!open) {
			getWharehouses()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [open])

	useEffect(() => {
		document.title = 'Almacenes'
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
						<span className='breadcrumb-item'>Almacenes</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getWharehouses()
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
			width: 100,
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
					<Tooltip title='Editar'>
						<Button
							type='text'
							icon={<EditOutlined />}
							disabled={userHasAccessToModule(MODULE, 'view', roles)}
							onClick={() => {
								loadWharehouseData(record.key)
							}}
						/>
					</Tooltip>
					<Tooltip title='Entrar'>
						<Button
							type='text'
							icon={<ArrowRightOutlined />}
							onClick={() => navigateToPath('/wharehouse', { Id: record.key })}
						/>
					</Tooltip>
				</Space>
			)
		},
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
		}
		// {
		// 	title: 'Despachos',
		// 	dataIndex: 'despachos',
		// 	render: (_, record) => (
		// 		<Tooltip title='3 Completadas / 3 En proceso / 6 Por hacer'>
		// 			<Progress
		// 				percent={60}
		// 				success={{ percent: 30 }}
		// 				status='active'
		// 				size='small'
		// 			/>
		// 		</Tooltip>
		// 	)
		// },
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

	const showWharehousesForm = () => {
		setOpen(true)
	}

	const closeWharehousesForm = () => {
		setOpen(false)
		setLoading(false)
	}

	const handleResetSuppliersForm = () => {
		setWharehouseFormInitialValues(createWharehouesesModel())
		setTitle('Registrar almacen')
		showWharehousesForm()
	}

	useEffect(() => {
		console.log(personal)
	}, [personal])

	return (
		<>
			<WharehouseForm
				title={title}
				open={open}
				onClose={closeWharehousesForm}
				estado={estado}
				initialValues={wharehouseFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
				personal={personal}
			/>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						{!userHasAccessToModule(MODULE, 'view', roles) ? (
							<Button
								type='primary'
								icon={<PlusOutlined />}
								onClick={handleResetSuppliersForm}
							>
								Nuevo Almacén
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
