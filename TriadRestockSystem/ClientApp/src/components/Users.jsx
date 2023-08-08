import {
	EditOutlined,
	ReloadOutlined,
	UserAddOutlined,
	UserOutlined
} from '@ant-design/icons'
import { Button, Col, Row, Space, Statistic, Tag } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
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
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
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
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
			width: 150,
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Nombre',
			dataIndex: 'nombre',
			key: 'nombre',
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Login',
			dataIndex: 'login',
			key: 'login',
			filterType: 'text search'
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
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
			filterType: 'date sorter',
			dateFormat: 'DD/MM/YYYY'
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
						onClick={() => handleEditUser(record)}
					>
						Editar
					</Button>
				</Space>
			)
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
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			getUsersData()
			getRolesItems()
			getCentrosCostosItems()

			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/users')}>
							<span className='breadcrumb-item'>
								<UserOutlined />
								<span className='breadcrumb-item-title'>Usuarios</span>
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
			<div className='info-container'>
				<Row align='end'>
					<Col span={3}>
						<Statistic
							style={{
								textAlign: 'end'
							}}
							title='Usuarios Activos'
							value={data.filter(u => u.estado === 'Activo').length}
						/>
					</Col>
					<Col span={3}>
						<Statistic
							style={{
								textAlign: 'end'
							}}
							title='Usuarios Inactivos'
							value={data.filter(u => u.estado === 'Inactivo').length}
						/>
					</Col>
					<Col span={3}>
						<Statistic
							style={{
								textAlign: 'end'
							}}
							title='Total Usuarios'
							value={data.length}
						/>
					</Col>
				</Row>
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
