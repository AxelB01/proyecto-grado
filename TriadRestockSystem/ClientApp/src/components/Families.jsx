import {
	EditOutlined,
	ReloadOutlined,
	UserAddOutlined
} from '@ant-design/icons'
import { Button, Space, Statistic } from 'antd'
import { useEffect, useRef, useState } from 'react'
// import Highlighter from 'react-highlight-words'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import CustomSimpleTable from './CustomSimpleTable'
import FamiliesForm from './FamiliesForm'

const FAMILIES_DATA_URL = '/api/familias/getFamilias'
const GET_FAMILY_DATA = '/api/familias/getFamilia'

const Families = () => {
	const [title, setTitle] = useState('')
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

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

	const [familyFormInitialValues, setFamiliesFormInitialValues] = useState({
		id: 0,
		nombre: ''
	})

	useEffect(() => {
		document.title = 'Familias'
		getFamiliesData()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

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
			dataIndex: 'familia',
			key: 'familia',
			fixed: 'left',
			filterType: 'text search'
		},
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
						onClick={() => handleEditFamily(record)}
					>
						Editar
					</Button>
				</Space>
			)
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
		setFamiliesFormInitialValues({
			id: 0,
			familia: ''
		})
		setTitle('Registrar Familia')
		showFamiliesForm()
	}
	const handleEditFamily = async record => {
		const { key } = record
		try {
			const editFamilyUrl = `${GET_FAMILY_DATA}?id=${key}`
			const respose = await axiosPrivate.get(editFamilyUrl)
			const { idFamilia, familia } = respose?.data
			const model = {
				id: idFamilia,
				familia
			}

			setFamiliesFormInitialValues({ ...model })
			setTitle('Editar familia')
			showFamiliesForm()
		} catch (error) {
			console.log(error)
		}
	}

	return (
		<>
			<FamiliesForm
				title={title}
				open={open}
				onClose={closeFamiliesForm}
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
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetFamiliesForm}
					>
						Nuevo familia
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
				<CustomSimpleTable
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
