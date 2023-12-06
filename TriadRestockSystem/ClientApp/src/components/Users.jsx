import {
	EditOutlined,
	HomeOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useUserStates from '../hooks/useUserStates'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import UserForm from './UserForm'

const USERS_DATA_URL = '/api/usuarios/getUsuarios'
const ROLES_URL = '/api/usuarios/getRoles'
const CENTROS_COSTOS_URL = '/api/usuarios/getCentrosCostos'
const GET_USER_URL = '/api/usuarios/getUsuario'

const Users = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	// const navigate = useNavigate()
	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)
	const [rolesItems, setRolesItems] = useState([])
	const [centrosCostosItems, setCentrosCostosItems] = useState([])

	const usuarioEstados = useUserStates()

	// User Form
	const [open, setOpen] = useState(false)
	const [title, setTitle] = useState('')

	const [userFormInitialValues, setUserFormInitialValues] = useState({
		id: 0,
		nombre: '',
		apellido: '',
		login: '',
		contrasena: '',
		confirmarContrasena: '',
		estado: 1,
		roles: [],
		centrosCostos: []
	})

	const handleResetUserForm = () => {
		setUserFormInitialValues({
			id: 0,
			nombre: '',
			apellido: '',
			login: '',
			contrasena: '',
			confirmarContrasena: '',
			estado: 1,
			roles: [],
			centrosCostos: []
		})
		setTitle('Registrar usuario')
		showUserForm()
	}

	// useEffect(() => {
	// 	console.log(userFormInitialValues)
	// }, [userFormInitialValues])

	const handleEditUser = async record => {
		const { key } = record
		try {
			const respose = await axiosPrivate.get(GET_USER_URL + `?id=${key}`)
			const {
				id,
				name,
				lastName,
				login,
				password,
				state,
				// email,
				roles,
				costCenters
			} = respose?.data
			const model = {
				id,
				nombre: name,
				apellido: lastName,
				login,
				contrasena: password,
				confirmarContrasena: password,
				estado: state,
				roles,
				centrosCostos: costCenters
			}

			setUserFormInitialValues({ ...model })
			setTitle('Editar usuario')
			showUserForm()
		} catch (error) {
			console.log(error)
		}
	}

	const showUserForm = () => {
		setOpen(true)
	}

	const closeUserForm = () => {
		setOpen(false)
		setLoading(false)
	}
	// User Form

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
			key: 'accion',
			fixed: 'left',
			width: 60,
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						type='text'
						icon={<EditOutlined />}
						onClick={() => handleEditUser(record)}
					/>
				</Space>
			)
		},
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			width: 110,
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			width: 250,
			filterType: 'text search'
		},
		{
			title: 'Login',
			dataIndex: 'login',
			key: 'login',
			width: 180,
			filterType: 'text search'
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			width: 100,
			filterType: 'custom filter',
			data: usuarioEstados,
			render: state => (
				<>
					{
						<Tag
							color={state === 'Inactivo' ? 'volcano' : 'geekblue'}
							key={state}
						>
							{state.toUpperCase()}
						</Tag>
					}
				</>
			)
		},
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			width: 200,
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			width: 140,
			filterType: 'text search',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		}
	]

	const getUsersData = async () => {
		try {
			const response = await axiosPrivate.get(USERS_DATA_URL)
			const data = response?.data
			setData(data)
			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

	const getRolesItems = async () => {
		try {
			const response = await axiosPrivate.get(ROLES_URL)
			const items = response?.data.items
			setRolesItems(items)
		} catch (error) {
			console.log(error)
		}
	}

	const getCentrosCostosItems = async () => {
		try {
			const response = await axiosPrivate.get(CENTROS_COSTOS_URL)
			const items = response?.data.items
			setCentrosCostosItems(items)
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Usuarios'
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
						<span className='breadcrumb-item'>Usuarios</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getUsersData()
				getRolesItems()
				getCentrosCostosItems()
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
			<UserForm
				open={open}
				onClose={closeUserForm}
				title={title}
				rolesItems={rolesItems}
				centrosCostosItems={centrosCostosItems}
				getUsersData={getUsersData}
				initialValues={userFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='info-container to-right'>
				<div
					style={{
						marginRight: '1.25rem'
					}}
				>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Usuarios Activos'
						value={data.filter(u => u.estado === 'Activo').length}
					/>
				</div>
				<div
					style={{
						marginRight: '1.25rem'
					}}
				>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Usuarios Inactivos'
						value={data.filter(u => u.estado === 'Inactivo').length}
					/>
				</div>
				<div>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Total Usuarios'
						value={data.length}
					/>
				</div>
			</div>
			<div className='page-content-container'>
				<div className='btn-container'>
					<div className='right'>
						<Button
							type='primary'
							icon={<UserAddOutlined />}
							onClick={handleResetUserForm}
						>
							Nuevo usuario
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
					/>
				</div>
			</div>
		</>
	)
}

export default Users
