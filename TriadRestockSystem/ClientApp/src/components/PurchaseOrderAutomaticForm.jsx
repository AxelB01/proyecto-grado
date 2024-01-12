import { FolderOpenOutlined } from '@ant-design/icons'
import { Button, Col, Empty, Input, Modal, Row, Table, Tag } from 'antd'
import locale from 'antd/lib/locale/es_ES'
import { useContext, useEffect, useRef, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createPurchaseOrderFormModel } from '../functions/constructors'
import { addThousandsSeparators } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const customNoDataText = (
	<Empty
		image={Empty.PRESENTED_IMAGE_SIMPLE}
		description='No existen registros'
	/>
)

const PurchaseOrderAutomaticForm = ({ status, toggle, initialValues }) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage, navigateToPath } = useContext(LayoutContext)

	const [tableKey] = useState(Date.now())
	const [tableStatus, setTableStatus] = useState(true)
	const tableRef = useRef()

	const [title, setTitle] = useState('')
	const [wharehouse, setWharehouse] = useState('')
	const [approvedDate, setApprovedDate] = useState('')
	const [archivingDate, setArchivingDate] = useState('')
	const [requisitionState, setRequisitionState] = useState('')
	const [finalTotal, setFinalTotal] = useState(0.0)
	const [baseTotal, setBaseTotal] = useState(0.0)
	const [taxesTotal, setTaxesTotal] = useState(0.0)
	const [data, setData] = useState([])
	const [loading, setLoading] = useState(false)
	const [selectedRowKeys, setSelectedRowKeys] = useState([])

	const [requisitionId, setRequisitionId] = useState(0)
	const [wharehouseId, setWharehouseId] = useState(0)

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

	const handleGeneratePurchaseOrder = () => {
		setLoading(true)
	}

	const generatePurchaseOrder = () => {
		const selectedItems = data.filter(d => selectedRowKeys.includes(d.key))
		const model = createPurchaseOrderFormModel()
		model.IdEstado = 0
		model.IdRequisicion = requisitionId
		model.IdAlmacen = wharehouseId
		model.ArticulosDetalles = selectedItems.map(i => {
			return {
				IdArticulo: i.idArticulo,
				Cantidad: i.cantidad,
				PrecioBase: i.precioBase,
				IdImpuesto: 0,
				Impuesto: i.impuesto,
				ImpuestoDecimal: i.impuestoDecimal
			}
		})

		setTimeout(() => {
			setLoading(false)
			navigateToPath('/purchaseOrder', model)
		}, 1000)
	}

	const columns = [
		{
			title: 'Código',
			dataIndex: 'codigo',
			key: 'codigo'
		},
		{
			title: 'Artículo',
			key: 'articulo',
			render: (_, record) => `${record.articulo} (${record.unidadMedida})`
		},
		{
			title: 'Marca',
			dataIndex: 'marca',
			key: 'marca'
		},
		{
			title: 'Familia',
			dataIndex: 'familia',
			key: 'familia',
			render: text => <Tag>{text}</Tag>
		},
		{
			title: 'Precio Base',
			dataIndex: 'precioBase',
			key: 'precioBase',
			render: text => `RD$ ${addThousandsSeparators(Number(text))}`
		},
		{
			title: 'Cantidad',
			dataIndex: 'cantidad',
			key: 'cantidad',
			render: text => Number(text).toFixed(2)
		},
		{
			title: 'Impuesto',
			key: 'impuesto',
			render: (_, record) =>
				`RD$ ${addThousandsSeparators(
					Number(record.precioBase * record.impuestoDecimal)
				)} (${record.impuesto})`
		},
		{
			title: 'Total (Estimado)',
			key: 'totalEstimado',
			render: (_, record) => (
				<div style={{ textAlign: 'end' }}>
					RD$ $
					{addThousandsSeparators(
						Number(
							record.cantidad *
								(record.precioBase * (1 + record.impuestoDecimal))
						)
					)}
				</div>
			)
		}
	]

	useEffect(() => {
		const total = data
			.filter(d => selectedRowKeys.includes(d.key))
			.reduce(
				(t, o) => t + o.precioBase * (1 + o.impuestoDecimal) * o.cantidad,
				0
			)
		const base = data
			.filter(d => selectedRowKeys.includes(d.key))
			.reduce((t, o) => t + o.precioBase * o.cantidad, 0)
		const tax = data
			.filter(d => selectedRowKeys.includes(d.key))
			.reduce((t, o) => t + o.precioBase * o.impuestoDecimal * o.cantidad, 0)

		setTaxesTotal(addThousandsSeparators(tax))
		setBaseTotal(addThousandsSeparators(base))
		setFinalTotal(addThousandsSeparators(total))
	}, [data, selectedRowKeys])

	useEffect(() => {
		if (Object.keys(initialValues).length !== 0) {
			console.log(initialValues)
			setTitle(`Requisición ${initialValues?.numero}`)
			setWharehouse(initialValues.almacen)
			setApprovedDate(initialValues.fechaAprobacionFormateada)
			setRequisitionState(initialValues.estado)
			setArchivingDate(initialValues.fechaArchivadoFormateada)
			setData(initialValues.detalles)

			setRequisitionId(initialValues.key)
			setWharehouseId(initialValues.idAlmacen)

			setTimeout(() => {
				setTableStatus(false)
			}, 400)
		}
	}, [initialValues])

	useEffect(() => {
		if (loading) {
			generatePurchaseOrder()
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [loading])

	return (
		<Modal
			title={title}
			open={status}
			onCancel={handleCancel}
			width={1200}
			style={{ top: 20 }}
			footer={[
				<Button key='btn-cancel' onClick={handleCancel}>
					Cancelar
				</Button>,
				<Button
					key='btn-save'
					type='primary'
					disabled={selectedRowKeys.length === 0}
					onClick={handleGeneratePurchaseOrder}
					loading={loading}
				>
					Generar
				</Button>
			]}
		>
			<Row style={{ marginBottom: '0.5rem' }} gutter={16}>
				<Col span={6}>
					<Input addonBefore='Almacén' value={wharehouse} />
				</Col>
				<Col span={7}>
					<Input addonBefore='Aprobación' value={approvedDate} />
				</Col>
				<Col span={7}>
					<Input addonBefore={<FolderOpenOutlined />} value={archivingDate} />
				</Col>
				<Col span={4}>
					<Input addonBefore='Estado' value={requisitionState} />
				</Col>
			</Row>
			<span style={{ fontWeight: 600 }}>
				{hasSelected
					? `Elementos seleccionados: ${selectedRowKeys.length}`
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
				summary={() => (
					<Table.Summary>
						<Table.Summary.Row>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell>
								<div style={{ textAlign: 'start' }}>
									<span
										style={{ fontWeight: 'bold' }}
									>{`RD$ ${baseTotal}`}</span>
								</div>
							</Table.Summary.Cell>
							<Table.Summary.Cell></Table.Summary.Cell>
							<Table.Summary.Cell>
								<div style={{ textAlign: 'start' }}>
									<span
										style={{ fontWeight: 'bold' }}
									>{`RD$ ${taxesTotal}`}</span>
								</div>
							</Table.Summary.Cell>
							<Table.Summary.Cell>
								<div style={{ textAlign: 'end' }}>
									<span
										style={{ fontWeight: 'bold' }}
									>{`RD$ ${finalTotal}`}</span>
								</div>
							</Table.Summary.Cell>
						</Table.Summary.Row>
					</Table.Summary>
				)}
				pagination={{
					total: data?.length,
					defaultPageSize: 10,
					showTotal: () => `${data?.length} registros en total`,
					locale: locale.Pagination
				}}
				locale={{
					customNoDataText
				}}
			/>
			{/* <Row gutter={16}>
				<Col style={{ textAlign: 'end' }} span={20}>
					<span style={{ fontWeight: 600 }}>Total estimado:</span>
				</Col>
				<Col span={4}>
					<span style={{ fontWeight: 600, marginLeft: '0.75rem' }}>
						{`RD$ ${total}`}
					</span>
				</Col>
			</Row> */}
		</Modal>
	)
}

export default PurchaseOrderAutomaticForm
