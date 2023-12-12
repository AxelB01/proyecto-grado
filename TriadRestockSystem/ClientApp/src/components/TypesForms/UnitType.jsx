import { EditOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import { Button, Space, Statistic } from 'antd'
import { useEffect, useRef, useState } from 'react'
import { createUnitTypeModel } from '../../functions/constructors'
import useAxiosPrivate from '../../hooks/usePrivateAxios'
import '../../styles/DefaultContentStyle.css'
import CustomTable from '../CustomTable'
import UnitTypeForm from './UnitTypeForm'

const UNIT_TYPE_GET = '/api/configuraciones/getUnidadMedida'
const UNIT_TYPE_URL = '/api/configuraciones/getUnidadesMedida'

const UnitType = () => {
	const axiosPrivate = useAxiosPrivate()
	const [types, setTypes] = useState([])

	const [open, setOpen] = useState(false)
	const [formLoading, setFormLoading] = useState(false)
	const [loading, setLoading] = useState({})

	const [initialValues, setInitialValues] = useState(createUnitTypeModel())

	const handleEditType = rowId => {
		setLoading(prevState => ({
			...prevState,
			[rowId]: true
		}))
		getType(rowId)
	}

	const handleOpen = value => {
		setOpen(value)
		if (!value) {
			setInitialValues(createUnitTypeModel())
		}
	}

	const handleLoading = value => {
		setFormLoading(value)
	}

	const getType = async id => {
		try {
			const response = await axiosPrivate.get(UNIT_TYPE_GET + `?id=${id}`)
			const data = response?.data
			const model = createUnitTypeModel()
			model.Id = data.id
			model.Nombre = data.nombre
			model.Codigo = data.codigo
			console.log(model)
			setInitialValues(model)
			setLoading(prevState => ({
				...prevState,
				[id]: false
			}))
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		const getTypes = async () => {
			try {
				const response = await axiosPrivate.get(UNIT_TYPE_URL)
				setTypes(response?.data)
				setTableState(false)
			} catch (error) {
				console.log(error)
			}
		}

		getTypes()
	}, [axiosPrivate, open])

	useEffect(() => {
		const { Id, Nombre, Codigo } = initialValues
		if (Id !== 0) {
			setOpen(true)
			setLoading(prevState => ({
				...prevState,
				[Id]: false,
				[Nombre]: false,
				[Codigo]: false
			}))
		}
	}, [initialValues])

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
			title: 'Codigo',
			dataIndex: 'codigo',
			key: 'codigo',
			filterType: 'text search'
		},
		{
			title: 'Acciones',
			key: 'action',
			render: (_, record) => (
				<Space size='middle' align='center'>
					<Button
						icon={<EditOutlined />}
						loading={loading[record.id]}
						onClick={() => handleEditType(record.id)}
					>
						Editar
					</Button>
				</Space>
			)
		}
	]

	return (
		<>
			<div className='page-content-container'>
				<UnitTypeForm
					open={open}
					handleOpen={handleOpen}
					loading={formLoading}
					handleLoading={handleLoading}
					initialValues={initialValues}
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
							value={types.length}
						/>
					</div>
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
							Nueva unidad de medida
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
						data={types}
						columns={columns}
					/>
				</div>
			</div>
		</>
	)
}

export default UnitType
