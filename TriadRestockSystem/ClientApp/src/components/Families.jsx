import {
	EditOutlined,
	HomeOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createFamiliesModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'
import FamiliesForm from './FamiliesForm'

const MODULE = 'Familias de artículos'

const FAMILIES_DATA_URL = '/api/familias/getFamilias'
const GET_FAMILY_DATA = '/api/familias/getFamilia'

const Families = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

	// const banks = useBanks().items
	// const banksAccounts = useBankAccounts().items

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

	const [familyFormInitialValues, setFamiliesFormInitialValues] = useState(
		createFamiliesModel()
	)

	useEffect(() => {
		document.title = 'Familias'
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
						<span className='breadcrumb-item'>Familias</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)

				getFamiliesData()
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
			key: 'accion',
			width: 60,
			render: (_, record) => (
				<Space size='middle' align='center'>
					{userHasAccessToModule(MODULE, 'creation', roles) ||
					userHasAccessToModule(MODULE, 'management', roles) ? (
						<Tooltip title='Editar'>
							<Button
								type='text'
								icon={<EditOutlined />}
								onClick={() => handleEditFamily(record)}
							/>
						</Tooltip>
					) : null}
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
			dataIndex: 'familia',
			key: 'familia',
			filterType: 'text search'
		},
		// {
		// 	title: 'Cuenta',
		// 	dataIndex: 'cuenta',
		// 	key: 'cuenta',
		// 	width: 450,
		// 	filterType: 'text search'
		// },
		{
			title: 'Total artículos',
			dataIndex: 'totalArticulos',
			key: 'totalArticulos'
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
		}
	]

	const getFamiliesData = async () => {
		try {
			const response = await axiosPrivate.get(FAMILIES_DATA_URL)
			const data = response?.data
			setData(data)
			setTableState(false)
		} catch (error) {
			console.log(error)
		}
	}

	const showFamiliesForm = () => {
		setOpen(true)
	}

	const closeFamiliesForm = () => {
		setOpen(false)
		setLoading(false)
	}

	const handleResetFamiliesForm = () => {
		setFamiliesFormInitialValues(createFamiliesModel())
		setTitle('Registrar Familia')
		showFamiliesForm()
	}

	const handleEditFamily = async record => {
		const { key } = record
		try {
			const respose = await axiosPrivate.get(`${GET_FAMILY_DATA}?id=${key}`)
			const data = respose?.data
			const model = createFamiliesModel()
			model.IdFamilia = data.idFamilia
			model.Familia = data.familia
			setFamiliesFormInitialValues(model)
			setTitle('Editar familia')
			showFamiliesForm()
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<FamiliesForm
				banks={[]}
				banksAccounts={[]}
				title={title}
				open={open}
				handleOpen={closeFamiliesForm}
				getFamilyData={getFamiliesData}
				initialValues={familyFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
			/>
			<div className='info-continer'>
				<Statistic
					style={{ textAlign: 'end' }}
					title='Familias'
					value={data.length}
				/>
			</div>
			<div className='btn-container'>
				<div className='right'>
					{userHasAccessToModule(MODULE, 'creation', roles) ||
					userHasAccessToModule(MODULE, 'management', roles) ? (
						<Button
							type='primary'
							icon={<UserAddOutlined />}
							onClick={handleResetFamiliesForm}
						>
							Nuevo familia
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
					data={data}
					columns={columns}
				/>
			</div>
		</>
	)
}
export default Families
