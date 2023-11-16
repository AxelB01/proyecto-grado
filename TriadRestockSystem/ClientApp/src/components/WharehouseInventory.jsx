import {
	AuditOutlined,
	CaretDownOutlined,
	EditOutlined
} from '@ant-design/icons'
import { Button, Dropdown, Modal, Space, Tag } from 'antd'
import { useEffect, useRef, useState } from 'react'
import { addThousandsSeparators } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import CustomTable from './CustomTable'
import WharehouseInventoryFilters from './WharehouseInventoryFilters'

const GET_WHAREHOUSE_INVENTORY = 'api/almacenes/inventarioAlmacen'

const inventoryItemMenu = [
	{
		key: '1',
		label: 'Editar',
		icon: <EditOutlined />
	},
	{
		key: '2',
		label: 'Historial',
		icon: <AuditOutlined />
	}
]

const WharehouseInventory = ({ status, toggle, id }) => {
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [filteredData, setFilteredData] = useState([])
	const [loading, setLoading] = useState(true)

	const [tableKey] = useState(Date.now)
	const tableRef = useRef()

	const handleCancel = () => {
		toggle()
		setTimeout(() => {
			setLoading(true)
		}, 500)
	}

	const getData = async () => {
		try {
			const response = await axiosPrivate.get(
				GET_WHAREHOUSE_INVENTORY + `?id=${id}`
			)
			if (response?.status === 200) {
				const data = response.data
				console.log(data)
				setData(data)
				setTimeout(() => {
					setLoading(false)
				}, 500)
			}
		} catch (error) {
			console.log(error)
			setLoading(false)
		}
	}

	useEffect(() => {
		if (status) {
			getData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [status])

	useEffect(() => {
		setFilteredData(data)
	}, [data])

	const columns = [
		{
			title: '',
			width: 60,
			fixed: 'left',
			render: record => (
				<Space size='middle' align='center'>
					<Dropdown
						menu={{
							items: inventoryItemMenu,
							onClick: ({ key }) => {
								console.log(key, record)
							}
						}}
					>
						<Button icon={<CaretDownOutlined />} />
					</Dropdown>
				</Space>
			)
		},
		{
			title: 'Artículo',
			width: 200,
			dataIndex: 'articulo',
			key: 'articulo'
		},
		{
			title: 'Código',
			width: 100,
			dataIndex: 'codigoArticulo',
			key: 'codigoArticulo'
		},
		{
			title: 'Número de serie',
			width: 150,
			dataIndex: 'numeroSerie',
			key: 'numeroSerie'
		},
		{
			title: 'Estado',
			width: 100,
			dataIndex: 'estado',
			key: 'estado',
			render: text => (
				<div style={{ display: 'flex', justifyContent: 'center' }}>
					{
						<Tag color={text === 'Activo' ? 'geekblue' : 'volcano'}>
							{text.toUpperCase()}
						</Tag>
					}
				</div>
			)
		},
		{
			title: 'Marca',
			width: 200,
			dataIndex: 'marca',
			key: 'marca'
		},
		{
			title: 'Modelo',
			width: 150,
			dataIndex: 'modelo',
			key: 'modelo'
		},
		{
			title: 'Precio compra',
			width: 150,
			dataIndex: 'precioCompra',
			key: 'precioCompra',
			render: text => <span>{addThousandsSeparators(text)}</span>
		},
		{
			title: 'Familia',
			width: 200,
			dataIndex: 'familia',
			key: 'familia'
		},
		{
			title: 'Seccion',
			width: 100,
			dataIndex: 'seccion',
			key: 'seccion'
		},
		{
			title: 'Estantería',
			width: 100,
			dataIndex: 'estanteria',
			key: 'estanteria'
		},
		{
			title: 'Registrado por',
			width: 250,
			dataIndex: 'nombreCompleto',
			key: 'nombreCompleto',
			render: text => <a style={{ color: '#2f54eb' }}>{text}</a>
		},
		{
			title: 'Fecha',
			width: 250,
			dataIndex: 'fechaRegistroFormateada',
			key: 'fechaRegistroFormateada'
		},
		{
			title: '',
			key: 'actions',
			render: () => <></>
		}
	]

	return (
		<Modal
			title='Inventario'
			open={status}
			onCancel={handleCancel}
			footer={[]}
			width={1200}
			style={{ top: 20 }}
		>
			<WharehouseInventoryFilters />
			<CustomTable
				tableKey={tableKey}
				tableRef={tableRef}
				tableState={loading}
				columns={columns}
				data={filteredData}
				scrollable={true}
				defaultPageSize={10}
				pagination={true}
			/>
		</Modal>
	)
}

export default WharehouseInventory
