import { DeleteOutlined } from '@ant-design/icons'
import { Button, InputNumber, Modal, Popconfirm, Select, Table } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createWharehouseItemsSortingModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_ITEMS_SORTING = 'api/almacenes/saveAlmacenArticulosOrdenamiento'

const WharehouseItemsSorting = ({ open, toggle, items, initialValues }) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const cancel = () => {
		toggle()
		setLoading(false)
	}

	const [data, setData] = useState([])
	const [currentPage, setCurrentPage] = useState(1)
	const [count, setCount] = useState(0)

	const [loading, setLoading] = useState(false)

	const handleChange = (value, key, dataIndex) => {
		const newData = [...data]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
			if (dataIndex === 'minimo' && target.maximo < value) {
				target.maximo = value
			}

			if (dataIndex === 'maximo' && target.minimo > value) {
				target.maximo = target.minimo
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
			const model = createWharehouseItemsSortingModel()
			model.Id = initialValues.Id
			model.Items = data.map(i => {
				return {
					Articulo: i.articulo,
					Minimo: i.minimo,
					Maximo: i.maximo
				}
			})

			try {
				const response = await axiosPrivate.post(SAVE_ITEMS_SORTING, model)
				if (response?.status === 200) {
					openMessage('success', 'Ordenamiento de artículos guardado')
				}
			} catch (error) {
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
			title: 'Mínimo',
			dataIndex: 'minimo',
			key: 'minimo',
			render: (text, record) => (
				<InputNumber
					value={text}
					min={1}
					onChange={value => handleChange(value, record.key, 'minimo')}
				/>
			)
		},
		{
			title: 'Máximo',
			dataIndex: 'maximo',
			key: 'maximo',
			render: (text, record) => (
				<InputNumber
					value={text}
					min={1}
					onChange={value => handleChange(value, record.key, 'maximo')}
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
						<Button type='text' icon={<DeleteOutlined />} />
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
				minimo: 1,
				maximo: 1
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
			const newData = []
			let count = 0

			initialValues.Items.forEach(i => {
				if (items.some(item => item.key === i.Articulo)) {
					const item = {
						key: count.toString(),
						articulo: i.Articulo,
						minimo: i.Minimo,
						maximo: i.Maximo
					}
					newData.push(item)
					count++
				}
			})
			setCount(count)
			setData(newData)
		}
	}, [initialValues, items])

	return (
		<>
			<Modal
				style={{
					top: 20
				}}
				title='Ordenamiento de artículos'
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
						onClick={saveData}
					>
						Guardar
					</Button>
				]}
			>
				<div>
					<Button onClick={handleAdd} style={{ marginBottom: 16 }}>
						Agregar
					</Button>
					<Table
						dataSource={data}
						columns={columns}
						pagination={{
							pageSize: 5,
							current: currentPage,
							onChange: page => setCurrentPage(page)
						}}
						rowKey='key'
					/>
				</div>
			</Modal>
		</>
	)
}

export default WharehouseItemsSorting
