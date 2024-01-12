import { DeleteOutlined } from '@ant-design/icons'
import {
	Button,
	Empty,
	InputNumber,
	Modal,
	Popconfirm,
	Select,
	Table
} from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createRequisitionsModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_REQUISICION = '/api/requisiciones/saveRequisicion'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const RequisitionEditModal = ({
	open,
	toggle,
	approveRequisition,
	items,
	itemsSorting,
	initialValues
}) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const cancel = () => {
		toggle()
		setLoading(false)
	}

	const handleApproveRequisition = () => {
		approveRequisition(initialValues.IdRequisicion)
		cancel()
	}

	const [title, setTitle] = useState('')
	const [edit, setEdit] = useState(true)
	const [data, setData] = useState([])
	const [currentPage, setCurrentPage] = useState(1)
	const [count, setCount] = useState(0)
	const [approve, setApprove] = useState(false)

	const [loading, setLoading] = useState(false)

	const handleChange = (value, key, dataIndex) => {
		const newData = [...data]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
			if (dataIndex === 'articulo') {
				console.log()
			}
			setData(newData)
		}
	}

	const handleDelete = key => {
		const newData = data.filter(item => item.key !== key)
		setData(newData)
	}

	const saveData = async () => {
		const emptyRows = data.some(o => o.articulo === null)
		const availableOptions = [
			...items.filter(i => !data.some(o => o.articulo === i.key))
		]
		if (availableOptions.length > 0 && !emptyRows) {
			setLoading(true)
			const model = createRequisitionsModel()
			model.IdAlmacen = initialValues.IdAlmacen
			model.IdRequisicion = initialValues.IdRequisicion
			model.Articulos = data.map(x => {
				return {
					IdArticulo: x.articulo,
					Key: '',
					Articulo: '',
					Codigo: '',
					IdFamilia: 0,
					Familia: '',
					IdUnidadMedida: 0,
					UnidadMedida: '',
					Cantidad: x.cantidad
				}
			})

			try {
				const response = await axiosPrivate.post(SAVE_REQUISICION, model)
				if (response?.status === 200) {
					openMessage('success', 'Requisició guardada correctamente')
				}
			} catch (error) {
				openMessage('error', 'Ha ocurrido un error inesperado')
				console.log(error)
			} finally {
				cancel()
			}
		} else {
			openMessage('warning', 'Existen registros incompletos')
		}
	}

	const columns = [
		{
			title: 'Artículo',
			dataIndex: 'articulo',
			key: 'articulo',
			render: (itemId, record) => (
				<Select
					style={{ width: 350 }}
					showSearch
					options={items
						.filter(i => !data.some(o => o.articulo === i.key))
						.map(i => {
							return { value: i.key, label: i.nombre }
						})}
					value={items.find(i => i.key === itemId)?.nombre ?? null}
					optionFilterProp='label'
					placeholder='Seleccionar un artículo...'
					onChange={value => handleChange(value, record.key, 'articulo')}
				/>
			)
		},
		{
			title: 'Cantidad',
			dataIndex: 'cantidad',
			key: 'cantidad',
			render: (text, record) => (
				<InputNumber
					value={text}
					min={1}
					status={
						itemsSorting.filter(x => x.Articulo === record.articulo)?.[0] !==
						undefined
							? itemsSorting.filter(x => x.Articulo === record.articulo)[0]
									.Maximo <
							  items.filter(x => x.idArticulo === record.articulo)[0]
									.existencias +
									text
								? 'warning'
								: ''
							: ''
					}
					onChange={value => handleChange(value, record.key, 'cantidad')}
					readOnly={!edit}
				/>
			)
		},
		{
			title: '',
			key: 'action',
			render: (_, record) => (
				<div style={{ display: 'flex', justifyContent: 'center' }}>
					<Popconfirm
						title='¿Eliminar este artículo?'
						cancelText='Cancelar'
						okText='Ok'
						onConfirm={() => handleDelete(record.key)}
					>
						<Button type='text' icon={<DeleteOutlined />} disabled={!edit} />
					</Popconfirm>
				</div>
			)
		}
	]

	const handleAdd = () => {
		const newData = [...data]
		const emptyRows = data.some(o => o.articulo === null)
		const availableOptions = [
			...items.filter(i => !data.some(o => o.articulo === i.key))
		]

		if (availableOptions.length > 0 && !emptyRows) {
			setCount(prevCount => prevCount + 1)
			newData.push({
				key: count.toString(),
				articulo: null,
				cantidad: 1
			})
			setData(newData)
			const lastPage = Math.ceil((newData.length + 1) / 5)
			setCurrentPage(lastPage)
		} else {
			openMessage('warning', 'No se pueden agregar nuevos registros')
		}
	}

	useEffect(() => {
		if (Object.keys(initialValues).length !== 0) {
			console.log(initialValues)
			if (initialValues.IdRequisicion !== 0) {
				setTitle(
					`Requisición de materiales ${initialValues.Numero} (${initialValues.Estado})`
				)
			} else {
				setTitle('Nueva requisición de materiales')
			}

			setApprove(initialValues.IdEstado === 1)

			const newData = []
			let count = 0

			initialValues.Articulos.forEach(i => {
				if (items.some(item => item.key === i.Articulo)) {
					const item = {
						key: count.toString(),
						articulo: i.Articulo,
						cantidad: i.Cantidad
					}
					newData.push(item)
					count++
				}
			})
			setCount(count)
			setData(newData)
			setEdit(initialValues.IdEstado === 1 || initialValues.IdEstado === 0)
		}
	}, [initialValues, items])

	return (
		<>
			<Modal
				style={{
					top: 20
				}}
				title={title}
				open={open}
				onCancel={cancel}
				width={900}
				footer={[
					<Button key='btn-cance' onClick={cancel}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						loading={loading}
						disabled={
							data.length === 0 || data.some(o => o.articulo === null) || !edit
						}
						onClick={saveData}
					>
						Guardar
					</Button>,
					<Popconfirm
						key='btn-approve'
						title='Aprobar requisición'
						description='¿Desea aprobar esta requisición?'
						okText='Sí'
						cancelText='Cancelar'
						onConfirm={handleApproveRequisition}
					>
						<Button
							loading={loading}
							disabled={
								data.length === 0 ||
								data.some(o => o.articulo === null) ||
								!approve ||
								!edit
							}
						>
							Aprobar
						</Button>
					</Popconfirm>
				]}
			>
				<div>
					{edit ? (
						<Button onClick={handleAdd} style={{ marginBottom: 16 }}>
							Agregar
						</Button>
					) : null}

					<Table
						dataSource={data}
						columns={columns}
						pagination={{
							pageSize: 5,
							current: currentPage,
							onChange: page => setCurrentPage(page)
						}}
						rowKey='key'
						locale={{
							emptyText: customNoDataText
						}}
					/>
				</div>
			</Modal>
		</>
	)
}

export default RequisitionEditModal
