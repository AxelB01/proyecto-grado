import { Button, Modal } from 'antd'
import '../styles/DefaultContentStyle.css'
import CustomTable from './CustomTable'

const columns = [
	{
		title: 'Nombre',
		dataIndex: 'nombre'
	},
	{
		title: 'Código',
		dataIndex: 'codigoArticulo'
	},
	{
		title: 'Cantidad',
		dataIndex: 'existencias'
	}
]

const WharehouseSectionStockModal = ({
	status,
	toggle,
	data,
	tableKey,
	handleTableKey,
	tableRef
}) => {
	const resetTable = () => {
		if (tableRef.current) {
			columns.forEach(column => {
				column.filteredValue = null
			})
		}

		handleTableKey()
	}

	const handleCancel = () => {
		toggle()
		resetTable()
	}

	return (
		<Modal
			title={`${data.codigo} - Existencias`}
			width={700}
			open={status}
			onCancel={handleCancel}
			footer={[
				<Button key='close' onClick={handleCancel}>
					Cerrar
				</Button>
			]}
		>
			<div>
				<CustomTable
					tableKey={tableKey}
					tableRef={tableRef}
					tableClases='custom-table-style no-hover'
					columns={columns}
					data={data.existencias}
					scrollable={false}
					defaultPageSize={5}
				/>
			</div>
		</Modal>
	)
}

export default WharehouseSectionStockModal
