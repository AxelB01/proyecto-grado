import {
	EditOutlined,
	HomeOutlined,
	MoneyCollectOutlined,
	PlusOutlined,
	ReloadOutlined,
	TagsOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic, Tooltip } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import {
	createCatalogDetailsModel,
	createCatalogModel
} from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useItems from '../hooks/useItems'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CatalogsCostCentersForm from './CatalogsCostCentersForm'
import CatalogsForm from './CatalogsForm'
import CatalogsItemsForm from './CatalogsItemsForm'
import CustomTable from './CustomTable'

const MODULE = 'Catálogos de artículos'

const CATALOGOS_GET = '/api/catalogos/getCatalogo'
const CATALOGOS_URL = '/api/catalogos/getCatalogos'

const Catalogs = () => {
	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const axiosPrivate = useAxiosPrivate()
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
		createCatalogDetailsModel()
	)

	const [costCentersLoadings, setCostCentersLoadings] = useState({})
	const [costCenters, setCostCenters] = useState([])
	const [costCentersFormInitialValues, setCostCentersFormInitialValues] =
		useState({})
	const [costCentersFormStatus, setCostCentersFormStatus] = useState(false)

	const handleCostCentersFormStatus = value => {
		setCostCentersFormStatus(value)
		if (!value) {
			setCostCentersFormInitialValues({})
		}
	}

	const handleEditCatalogCostCenters = rowId => {
		setCostCentersLoadings(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getCatalogCostCenters(rowId)
	}

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
			setInitialValues(createCatalogDetailsModel())
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
		const model = createCatalogDetailsModel()
		model.Id = record.id
		model.Nombre = record.nombre
		model.Detalle = record.articulos
		setCatalogItemsInitialValues(model)
	}

	const getCatalogCostCenters = record => {
		const model = createCatalogDetailsModel()
		model.Id = record.id
		model.Nombre = record.nombre
		model.IdsCentrosCostos = record.centrosCostos

		setCostCentersFormInitialValues(model)
	}

	useEffect(() => {
		const getCatalogs = async () => {
			try {
				const response = await axiosPrivate.get(CATALOGOS_URL)
				const data = response?.data
				setCatalogs(data.catalogs)
				setCostCenters(
					data.costCenters.map(c => {
						return {
							key: c.key,
							text: c.text,
							shortText: c.text
						}
					})
				)
				setTableState(false)
			} catch (error) {
				console.log(error)
			}
		}

		getCatalogs()
	}, [axiosPrivate, open, openItemsForm, costCentersFormStatus])

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
		if (Object.keys(costCentersFormInitialValues).length !== 0) {
			handleCostCentersFormStatus(true)
			setCostCentersLoadings(prevState => ({
				...prevState,
				[costCentersFormInitialValues.Id]: false
			}))
		}
	}, [costCentersFormInitialValues])

	useEffect(() => {
		if (!openItemsForm) {
			setCatalogItemsInitialValues(createCatalogDetailsModel())
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
			title: '',
			key: 'action',
			width: 60,
			render: (_, record) => (
				<Space size='middle' align='center'>
					{userHasAccessToModule(MODULE, 'creation', roles) ||
					userHasAccessToModule(MODULE, 'management', roles) ? (
						<Tooltip title='Editar'>
							<Button
								type='text'
								icon={<EditOutlined />}
								loading={loading[record.id]}
								onClick={() => handleEditCatalogs(record.id)}
							/>
						</Tooltip>
					) : null}
					<Tooltip title='Artículos'>
						<Button
							type='text'
							icon={<TagsOutlined />}
							loading={loading2[record.id]}
							onClick={() => handleEditCatalogsItems(record)}
						/>
					</Tooltip>
					<Tooltip title='Centros de costo'>
						<Button
							type='text'
							icon={<MoneyCollectOutlined />}
							loading={costCentersLoadings[record.id]}
							onClick={() => handleEditCatalogCostCenters(record)}
						/>
					</Tooltip>
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
			title: 'Centros de costos',
			dataIndex: 'totalCentrosCosto',
			key: 'totalCentrosCosto',
			filterType: 'sorter',
			sortKey: 'totalCentrosCosto'
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
		}
	]

	useEffect(() => {
		document.title = 'Catálogos'
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
						<span className='breadcrumb-item'>Catálogos</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)
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

	useEffect(() => {
		console.log(catalogs)
	}, [catalogs])

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
				<CatalogsCostCentersForm
					open={costCentersFormStatus}
					handleOpen={handleCostCentersFormStatus}
					source={costCenters}
					initialValues={costCentersFormInitialValues}
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
						{userHasAccessToModule(MODULE, 'creation', roles) ||
						userHasAccessToModule(MODULE, 'management', roles) ? (
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
						data={catalogs}
						columns={columns}
					/>
				</div>
			</div>
		</>
	)
}

export default Catalogs
