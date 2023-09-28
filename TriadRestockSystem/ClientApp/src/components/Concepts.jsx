import {
	FormOutlined,
	PlusOutlined,
	ReloadOutlined
} from '@ant-design/icons'

import {
	Button,

} from 'antd'

import { useState,useEffect } from 'react'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import ConceptsForm from './ConceptsForm'
import { createConceptModel } from '../functions/constructors'

const ALMACENES_SECCIONES_URL = '/api/data/getAlmacenSecciones'
const ALMACENES_SECCIONES_ESTANTERIAS_URL = '/api/data/getAlmacenSecciones'
const ALMACEN_GET = '/api/data/getAlmacenSecciones'

const Concepts = () => {

    const [sectionShelves, setSectionShelves] = useState(null)
	const [wharehouseSections, setWharehouseSections] = useState(null)
	const axiosPrivate = useAxiosPrivate()
	const [customState, setCustomState] = useState(null)
	//const [viewModel, setViewModel] = useState({})
    //const [wharehouseData, setWharehouseData] = useState({})
	const [sectionFormValues, setSectionFormValues] = useState(
		createConceptModel()
	)
	const [shelvesInUse, setShelvesInUse] = useState(0)
	const [shelves, setShelves] = useState(0)
    
    const [openSectionForm, setOpenSectionForm] = useState(false)
	const [buttonInventoryEntryLoading, setButtonInventoryEntryLoading] =
		useState(false)


    const handleOpenInventoryEntryForm = value => {
		if (value) {
			getWharehouseSections()
			getWharehouseSectionShelves()

		} else {
			setWharehouseSections(null)
			setSectionShelves(null)
		}
	}
	
    const getWharehouseSections = async () => {
		try {
			const response = await axiosPrivate.get(ALMACENES_SECCIONES_URL)
			const items = response?.data.items
			setWharehouseSections(items)
		} catch (error) {
			console.log(error)
		}
	}
	// wasdasd
    useEffect(() => {
		if (
			wharehouseSections !== null &&
			sectionShelves !== null 
		) {
			console.log(wharehouseSections, sectionShelves)
			setButtonInventoryEntryLoading(false)
		}
	}, [wharehouseSections, sectionShelves])

  

	const getWharehouseSectionShelves = async () => {
		try {
			const response = await axiosPrivate.get(
				ALMACENES_SECCIONES_ESTANTERIAS_URL
			)
			const items = response?.data.items
			setSectionShelves(items)
		} catch (error) {
			console.log(error)
		}
	}

    const loadWharehouseData = async () => {
		try {
			const response = await axiosPrivate.get(
				ALMACEN_GET + `?id=${customState}`
			)

			if (response?.status === 200) {
				const data = response?.data

				setViewModel(data)

				setWharehouseData(data.almacen)
				setSections(data.secciones)

				let shelves = 0
				let shelvesInUSe = 0

				data.secciones.forEach(seccion => {
					shelves += seccion.estanterias.length
					shelvesInUSe += seccion.estanterias.filter(
						e => e.existencias > 0 && e.idEstado === 1
					).length
				})

				setShelves(shelves)
				setShelvesInUse(shelvesInUSe)

				setRequests(data.solicitudesMateriales)
				setProcurementOrders(data.ordenesCompras)

				const sectionFormModelValues = createWharehouseSectionModel()
				sectionFormModelValues.IdAlmacen = data.almacen.idAlmacen
				setSectionFormValues(sectionFormModelValues)

				setTableState(false)
			}
		} catch (error) {
			console.log(error)
		}
	}

    useEffect(() => {
		const { state } = location
		setCustomState(state)

		document.title = 'Almacén'
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
								<span className='breadcrumb-item-title'>Conceptos</span>
							</span>
						</a>
					)
				},
				{
					title: (
						<a>
							<span className='breadcrumb-item'>
								<span className='breadcrumb-item-title'>Concepto</span>
							</span>
						</a>
					)
				}
			]
			handleBreadcrumb(breadcrumbItems)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [location])

	useEffect(() => {
		loadWharehouseData()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

    
    return(
        <>
        <div className='page-content-container'>
            <ConceptsForm
                initialValues={sectionFormValues}
                conceptParent={zonesTypes}
                open={openSectionForm}
                handleOpen={handleOpenSectionForm}
                loading={sectionFormLoading}
                handleLoading={handleSectionFormLoading}
                    />

            <div className='main-two-container'>
					<div className='actions'>
						<Button
							type='primary'
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<PlusOutlined />}
							onClick={() => {
								setOpenSectionForm(true)
							}}
						>
							Agregar sección
						</Button>
						<Button
							type='primary'
							style={{
								display: 'flex',
								alignItems: 'center'
							}}
							icon={<FormOutlined />}
							onClick={() => {
								handleOpenInventoryEntryForm(true)
							}}
							loading={buttonInventoryEntryLoading}
						>
							Nueva entrada de inventario
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
					<div className='container-content'>
						<CustomTable
							tableKey={tableKey}
							tableRef={tableRef}
							tableState={tableState}
							expandedRowRender={expandedRowRender}
							data={sections}
							columns={columns}
							scrollable={false}
							pagination={false}
						/>
					</div>
				</div>
            </div>
        </>
    );
}
export default Concepts