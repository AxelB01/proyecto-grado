import { Button, Empty, Modal, Table, Tag } from 'antd'
import locale from 'antd/lib/locale/es_ES'
import { useContext, useEffect, useRef, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createRequisitionsModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const REQUISICION_GET_ITEMS = '/api/requisiciones/getRequisicionArticulos'
const SAVE_REQUISICION = '/api/requisiciones/saveRequisicionAutomatica'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const RequisitionAutomaticForm = ({ status, toggle, id }) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)

	const [tableKey] = useState(Date.now())
	const [tableStatus, setTableStatus] = useState(true)
	const tableRef = useRef()

	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)
	const [selectedRowKeys, setSelectedRowKeys] = useState([])

	const onSelectChange = newSelectedRowKeys => {
		setSelectedRowKeys(newSelectedRowKeys)
	}

	const rowSelection = {
		selectedRowKeys,
		onChange: onSelectChange
	}

	const hasSelected = selectedRowKeys.length > 0

	const handleCancel = () => {
		setSelectedRowKeys([])
		toggle()
	}

	const handleGenerate = () => {
		setLoading(true)
		const model = createRequisitionsModel()
		model.IdAlmacen = id
		model.Articulos = data
			.filter(x => selectedRowKeys.includes(x.idArticulo))
			.map(x => {
				return {
					IdArticulo: x.idArticulo,
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
		saveRequisition(model)
	}

	const saveRequisition = async model => {
		console.log(model)
		try {
			const response = await axiosPrivate.post(SAVE_REQUISICION, model)
			if (response?.status === 200) {
				openMessage('success', 'Requisición guardada correctamente')
				setTableStatus(true)
				handleCancel()
			}
		} catch (error) {
			console.log(error)
		} finally {
			setLoading(false)
		}
	}

	const getData = async id => {
		try {
			const response = await axiosPrivate.get(
				REQUISICION_GET_ITEMS + `?id=${id}`
			)

			if (response?.status === 200) {
				setData(response.data)
				setTimeout(() => {
					setTableStatus(false)
				}, 500)
			}
		} catch (error) {
			console.log(error)
		}
	}

	useEffect(() => {
		if (id !== undefined && tableStatus) {
			getData(id)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [id, tableStatus])

	const columns = [
		{
			title: 'Artículo',
			dataIndex: 'articulo',
			key: 'articulo'
		},
		{
			title: 'Código',
			dataIndex: 'codigo',
			key: 'codigo'
		},
		{
			title: 'Unidad de medida',
			dataIndex: 'unidadMedida',
			key: 'unidadMedida'
		},
		{
			title: 'Familia',
			dataIndex: 'familia',
			key: 'familia',
			render: text => <Tag>{text}</Tag>
		},
		{
			title: 'Cantidad requerida',
			dataIndex: 'cantidad',
			key: 'cantidad'
		}
	]

	return (
		<Modal
			title='Requisición automática'
			open={status}
			onCancel={handleCancel}
			width={1000}
			style={{
				top: 20
			}}
			footer={[
				<Button key='btn-cancel' onClick={handleCancel}>
					Cancel
				</Button>,
				<Button
					key='btn-save'
					type='primary'
					disabled={!hasSelected}
					loading={loading}
					onClick={handleGenerate}
				>
					Generar
				</Button>
			]}
		>
			<span>
				{hasSelected
					? `Artículos seleccionados: ${selectedRowKeys.length}`
					: ''}
			</span>
			<br />
			<Table
				key={tableKey}
				ref={tableRef}
				loading={tableStatus}
				rowSelection={rowSelection}
				columns={columns}
				dataSource={data}
				pagination={{
					total: data?.length,
					defaultPageSize: 10,
					showTotal: () => `${data?.length} registros en total`,
					locale: locale.Pagination
				}}
				locale={{
					customNoDataText
				}}
			></Table>
		</Modal>
	)
}

export default RequisitionAutomaticForm
