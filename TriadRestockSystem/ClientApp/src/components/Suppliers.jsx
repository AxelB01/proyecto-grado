import {
	EditOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import useCountries from '../hooks/useCountries'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import useSupplierStates from '../hooks/useSupplierStates'
import useSuppliersTypes from '../hooks/useSuppliersTypes'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import SuppliersForm from './SuppliersForm'

const SUPPLIERS_DATA_URL = '/api/proveedores/getProveedores'
const GET_SUPPLIER_DATA = '/api/proveedores/getProveedor'

const Suppliers = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)
	const navigate = useNavigate()

	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

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

	const paisesItems = useCountries()
	const estadosProveedores = useSupplierStates()
	const tipoProveedores = useSuppliersTypes()

	const [suppliersFormInitialValues, setSuppliersFormInitialValues] = useState({
		id: 0,
		idEstado: 0,
		nombre: '',
		rnc: '',
		idPais: 0,
		direccion: '',
		codigoPostal: '',
		telefono: '',
		correo: '',
		fechaUltimaCompra: ''
	})

	const columns = [
		{
			title: 'Código',
			dataIndex: 'id',
			key: 'id',
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
			title: 'RNC',
			dataIndex: 'rnc',
			key: 'rnc',
			fixed: 'left',
			filterType: 'text search'
		},
		{
			title: 'Tipo',
			dataIndex: 'tipoProveedor',
			key: 'tipoProveedor',
			filterType: 'text search'
		},
		{
			title: 'Estado',
			dataIndex: 'estado',
			key: 'estado',
			filterType: 'custom filter',
			data: estadosProveedores
			// render: text => (<>{<Tag key={text}>{text.toUpperCase()}</Tag>}</>)
		},
		{
			title: 'Pais',
			dataIndex: 'pais',
			key: 'pais',
			width: 100,
			filterType: 'text search'
		},
		{
			title: 'Direccion',
			dataIndex: 'direccion',
			key: 'direccion',
			width: 300,
			filterType: 'text search'
		},
		{
			title: 'Codigo postal',
			dataIndex: 'codigoPostal',
			key: 'codigoPostal',
			width: 100,
			filterType: 'text search'
		},
		{
			title: 'Telefono',
			dataIndex: 'telefono',
			key: 'telefono',
			filterType: 'text search'
		},
		{
			title: 'Correo electronico',
			dataIndex: 'correoElectronico',
			key: 'correoElectronico',
			width: 100,
			filterType: 'text search'
		},
		// {
		// 	title: 'Fecha de ultima compra',
		// 	dataIndex: 'fechaUltimaCompra',
		// 	key: 'fechaUltimaCompra',
		// 	filterType: 'date sorter',
		// 	dateFormat: 'DD/MM/YYYY'
		// },
		{
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
			filterType: 'date sorter',
			// width: 200,
			dateFormat: 'DD/MM/YYYY'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			ilterType: 'text search',
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
						onClick={() => handleEditSupplier(record)}
					>
						Editar
					</Button>
				</Space>
			)
		}
	]

	const getSuppliersData = async () => {
		try {
			const response = await axiosPrivate.get(SUPPLIERS_DATA_URL)
			const data = response?.data
			setData(data)
			console.log(data)
		} catch (error) {
			console.log(error)
		}
	}

	const showSuppliersForm = () => {
		setOpen(true)
	}

	const closeSuppliersForm = () => {
		setOpen(false)
		setLoading(false)
	}

	const handleResetSuppliersForm = () => {
		setSuppliersFormInitialValues({
			id: 0,
			IdEstado: 0,
			IdTipoProveedor: 0,
			Nombre: '',
			RNC: '',
			IdPais: 0,
			Direccion: '',
			CodigoPostal: '',
			Telefono: '',
			Correo: '',
			FechaUltimaCompra: ''
		})
		setTitle('Registrar Suplidor')
		showSuppliersForm()
	}
	const handleEditSupplier = async record => {
		const { key } = record
		try {
			const editSupplierUrl = `${GET_SUPPLIER_DATA}?id=${key}`
			const respose = await axiosPrivate.get(editSupplierUrl)

			const {
				Id,
				IdEstado,
				IdTipoProveedor,
				Nombre,
				RNC,
				IdPais,
				Direccion,
				CodigoPostal,
				Telefono,
				Correo
			} = respose?.data
			const model = {
				id: Id,
				idEstado: IdEstado,
				tipoProveedor: IdTipoProveedor,
				nombre: Nombre,
				rnc: RNC,
				idPais: IdPais,
				direccion: Direccion,
				codigoPostal: CodigoPostal,
				telefono: Telefono,
				correo: Correo
			}

			setSuppliersFormInitialValues({ ...model })
			setTitle('Editar proveedor')
			showSuppliersForm()
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		document.title = 'Proveedores'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			getSuppliersData()

			const breadcrumbItems = [
				{
					title: (
						<a onClick={() => navigate('/suppliers')}>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Proveedores</span>
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
			<SuppliersForm
				title={title}
				open={open}
				onClose={closeSuppliersForm}
				getSuppliersData={getSuppliersData}
				tipoProveedorItem={tipoProveedores}
				paisesItems={paisesItems}
				initialValues={suppliersFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='info-continer'>
				<Statistic
					style={{ textAlign: 'end' }}
					title='Suplidores'
					value={data.length}
				/>
			</div>
			<div className='btn-container'>
				<div className='right'>
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetSuppliersForm}
					>
						Nuevo Suplidor
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
					data={data}
					columns={columns}
					scrollable={true}
				/>
			</div>
		</>
	)
}
export default Suppliers
