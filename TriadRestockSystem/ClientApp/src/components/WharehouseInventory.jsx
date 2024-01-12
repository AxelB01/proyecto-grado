import { CaretDownOutlined, EditOutlined } from '@ant-design/icons'
import { Button, Dropdown, Modal, Space, Tag } from 'antd'
import { useEffect, useRef, useState } from 'react'
import { createWharehouseInventoryPositionForm } from '../functions/constructors'
import {
	addThousandsSeparators,
	containsIgnoreCase
} from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import CustomTable from './CustomTable'
import WharehouseInventoryFilters from './WharehouseInventoryFilters'
import WharehouseInventoryFormModel from './WharehouseInventoryFormModel'

const GET_WHAREHOUSE_INVENTORY = 'api/almacenes/inventarioAlmacen'

const inventoryItemMenu = [
	{
		key: '1',
		label: 'Editar',
		icon: <EditOutlined />
	}
]

const WharehouseInventory = ({ status, toggle, id }) => {
	const axiosPrivate = useAxiosPrivate()
	const [data, setData] = useState([])
	const [filteredData, setFilteredData] = useState([])
	const [loading, setLoading] = useState(true)

	const [brands, setBrands] = useState([])
	const [families, setFamilies] = useState([])
	const [positions, setPositions] = useState([])

	const [tableKey] = useState(Date.now)
	const tableRef = useRef()

	const [wharehouseInventorymModalStatus, setWharehouseInventoryStatus] =
		useState(false)

	const [wharehouseInventoryModalValues, setWharehouseInventoryModalValues] =
		useState({})

	const handleWharehouseInventoryModalStatus = () => {
		setWharehouseInventoryStatus(!wharehouseInventorymModalStatus)
	}

	const handleEditItemInventory = record => {
		const model = createWharehouseInventoryPositionForm()
		model.IdInventario = record.idInventario
		model.Articulo = `${record.articulo} (${record.marca})`
		model.Codigo = record.numeroSerie
		model.Posicion = [
			id,
			record.idAlmacenSeccion,
			record.idAlmacenSeccionEstanteria
		]

		setWharehouseInventoryModalValues(model)
	}

	const handleCancel = () => {
		toggle()
		setTimeout(() => {
			setLoading(true)
		}, 500)
	}

	const getData = async () => {
		try {
			setLoading(true)
			const response = await axiosPrivate.get(
				GET_WHAREHOUSE_INVENTORY + `?id=${id}`
			)
			if (response?.status === 200) {
				const data = response.data
				setData(data.inventario)
				setBrands(
					data.marcas.map(b => {
						return {
							value: b.key,
							label: b.text
						}
					})
				)
				setFamilies(
					data.familias.map(f => {
						return {
							value: f.key,
							label: f.text
						}
					})
				)
				setPositions(data.posiciones)
				setTimeout(() => {
					setLoading(false)
				}, 500)
			}
		} catch (error) {
			console.log(error)
			setLoading(false)
		}
	}

	const filterData = (value, dataIndex, marca, familia) => {
		let newData = [...data]
		if (value && dataIndex) {
			newData = filteredData.filter(i =>
				containsIgnoreCase(i[dataIndex], value)
			)
		}
		if (marca) {
			newData = newData.filter(i => i.idMarca === marca)
		}
		if (familia) {
			newData = newData.filter(i => i.idFamilia === familia)
		}
		setFilteredData(newData)
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

	useEffect(() => {
		console.log(wharehouseInventoryModalValues)
		if (Object.keys(wharehouseInventoryModalValues).length !== 0) {
			handleWharehouseInventoryModalStatus()
		} else {
			getData()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [wharehouseInventoryModalValues])

	useEffect(() => {
		if (!wharehouseInventorymModalStatus) {
			getData()
			setWharehouseInventoryModalValues({})
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [wharehouseInventorymModalStatus])

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
								handleEditItemInventory(record)
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
			width: 300,
			dataIndex: 'articulo',
			key: 'articulo',
			render: (_, record) => (
				<span>{`${record.articulo} (${record.marca})`}</span>
			)
		},
		{
			title: 'Código',
			width: 100,
			dataIndex: 'codigoArticulo',
			key: 'codigoArticulo'
		},
		{
			title: 'No. Serie (Codigo Barra)',
			width: 200,
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
		// {
		// 	title: 'Marca',
		// 	width: 200,
		// 	dataIndex: 'marca',
		// 	key: 'marca'
		// },
		{
			title: 'Costo',
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
		}
	]

	return (
		<>
			<WharehouseInventoryFormModel
				initialValues={wharehouseInventoryModalValues}
				open={wharehouseInventorymModalStatus}
				toggle={handleWharehouseInventoryModalStatus}
				options={positions}
			/>
			<Modal
				title='Inventario'
				open={status}
				onCancel={handleCancel}
				footer={[]}
				width={1200}
				style={{ top: 20 }}
			>
				<WharehouseInventoryFilters
					filteredData={filterData}
					brands={brands}
					families={families}
				/>
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
		</>
	)
}

export default WharehouseInventory
