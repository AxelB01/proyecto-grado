import { DeleteOutlined } from '@ant-design/icons'
import { Button, InputNumber, Modal, Popconfirm, Select, Table } from 'antd'
import { useContext, useState } from 'react'
import LayoutContext from '../context/LayoutContext'

const WharehouseItemsSorting = ({ open, toggle, items, initialValues }) => {
	const { openMessage } = useContext(LayoutContext)

	const cancel = () => {
		toggle()
	}

	const [data, setData] = useState([])
	const [currentPage, setCurrentPage] = useState(1)
	const [count, setCount] = useState(0)

	const handleChange = (value, key, dataIndex) => {
		const newData = [...data]
		const target = newData.find(item => item.key === key)
		if (target) {
			target[dataIndex] = value
			console.log(target)
			setData(newData)
		}
	}

	const handleDelete = key => {
		const newData = data.filter(item => item.key !== key)
		setData(newData)
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
							return { value: i.key, label: i.text }
						})}
					value={items.find(i => i.key === itemId)?.text ?? null}
					optionFilterProp='label'
					placeholder='Seleccionar un artículo...'
					onChange={value => handleChange(value, record.key, 'articulo')}
				/>
			)
		},
		{
			title: 'Mínimo',
			dataIndex: 'number1',
			key: 'number1',
			render: (text, record) => (
				<InputNumber
					value={text}
					onChange={value => handleChange(value, record.key, 'number1')}
				/>
			)
		},
		{
			title: 'Máximo',
			dataIndex: 'number2',
			key: 'number2',
			render: (text, record) => (
				<InputNumber
					value={text}
					onChange={value => handleChange(value, record.key, 'number2')}
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
				number1: 0,
				number2: 0
			})
			setData(newData)
			const lastPage = Math.ceil((newData.length + 1) / 5)
			setCurrentPage(lastPage)
		} else {
			openMessage('warning', 'No se pueden agregar nuevos registros')
		}
	}

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
					</Button>
				]}
			>
				<div>
					<Button onClick={handleAdd} style={{ marginBottom: 16 }}>
						Add Row
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
