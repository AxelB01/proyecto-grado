import {
	EditOutlined,
	PlusOutlined,
	ReloadOutlined,
	TagsOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import {
	createCatalogItemsModel,
	createCatalogModel
} from '../functions/constructors'
import { sleep } from '../functions/sleep'
import useItems from '../hooks/useItems'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CatalogsForm from './CatalogsForm'
import CatalogsItemsForm from './CatalogsItemsForm'
import CustomTable from './CustomTable'

const CATALOGOS_GET = '/api/catalogos/getCatalogo'
const CATALOGOS_URL = '/api/catalogos/getCatalogos'

const Catalogs = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb } = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
	const navigate = useNavigate()
	const [catalogs, setCatalogs] = useState([])

	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

	const [openItemsForm, setOpenItemsForm] = useState(false)
	const [itemsFormLoading, setItemsFormLoading] = useState(false)
	const [loading2, setLoading2] = useState({})
	const itemsList = useItems()

	const [initialValues, setInitialValues] = useState(createCatalogModel())

	const [catalogItemsInitialValues, setCatalogItemsInitialValues] = useState(
		createCatalogItemsModel()
	)

	const handleEditCatalogs = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getCatalog(rowId)
	}

	const handleOpen = value => {
		setOpen(value)
		if (!value) {
			setInitialValues(createCatalogModel())
		}
	}

	const handleLoading = value => {
		setFormLoading(value)
	}

	const handleEditCatalogsItems = record => {
		setLoading2(prevState => ({
			...prevState,
			[record.id]: true
		}))
		getCatalogItems(record)
	}

	const handleOpenItemsForm = value => {
		setOpenItemsForm(value)
		if (!value) {
			setInitialValues(createCatalogItemsModel())
		}
	}

	const handleLoadingCatalogsItems = value => {
		setItemsFormLoading(value)
	}

	const getCatalog = async id => {
		try {
			const response = await axiosPrivate.get(CATALOGOS_GET + `?id=${id}`)
			const data = response?.data
			const model = createCatalogModel()
			model.Id = data.id
			model.Nombre = data.nombre
			setInitialValues(model)
			setLoading(prevState => ({
				...prevState,
				[id]: false
			}))
		} catch (error) {
			console.log(error)
		}
	}

	const getCatalogItems = record => {
		const model = createCatalogItemsModel()
		model.Id = record.id
		model.Nombre = record.nombre
		model.Detalle = record.articulos
		setCatalogItemsInitialValues(model)
	}

	useEffect(() => {
		const getCatalogs = async () => {
			try {
				const response = await axiosPrivate.get(CATALOGOS_URL)
				setCatalogs(response?.data)
				setTableState(false)
			} catch (error) {
				console.log(error)
			}
		}

		getCatalogs()
	}, [axiosPrivate, open, openItemsForm])

	useEffect(() => {
		const { Id } = initialValues
		if (Id !== 0) {
			setOpen(true)
			setLoading(prevState => ({
				...prevState,
				[Id]: false
			}))
		}
	}, [initialValues])

	useEffect(() => {
		const { Id } = catalogItemsInitialValues
		if (Id !== 0) {
			setOpenItemsForm(true)
			setLoading2(prevState => ({
				...prevState,
				[Id]: false
			}))
		}
	}, [catalogItemsInitialValues])

	useEffect(() => {
		if (!openItemsForm) {
			setCatalogItemsInitialValues(createCatalogItemsModel())
		}
	}, [openItemsForm])

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
			title: 'Total Artículos',
			dataIndex: 'totalArticulos',
			key: 'totalArticulos',
			filterType: 'sorter',
			sortKey: 'totalArticulos'
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
						onClick={() => handleEditCatalogs(record.id)}
					>
						Editar
					</Button>
					<Button
						icon={<TagsOutlined />}
						loading={loading2[record.id]}
						onClick={() => handleEditCatalogsItems(record)}
					>
						Artículos
					</Button>
				</Space>
			)
		}
	]

	useEffect(() => {
		document.title = 'Catalogos'
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
						<a onClick={() => navigate('/catalogs')}>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Catalogos</span>
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
				<CatalogsForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
				/>
				<CatalogsItemsForm
					open={openItemsForm}
					handleOpen={handleOpenItemsForm}
					loading={itemsFormLoading}
					handleLoading={handleLoadingCatalogsItems}
					source={itemsList.items}
					initialValues={catalogItemsInitialValues}
				/>
				<div className='info-container to-right'>
					<Statistic
						style={{
							textAlign: 'end'
						}}
						title='Catálogos'
						value={catalogs.length}
					/>
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
							Nuevo Catálogo
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
						data={catalogs}
						columns={columns}
					/>
				</div>
			</div>
		</>
	)
}

export default Catalogs
