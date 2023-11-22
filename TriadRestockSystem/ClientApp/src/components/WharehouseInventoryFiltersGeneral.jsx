import { Col, Form, Input, Row, Select } from 'antd'

const fields = [
	{
		value: 'articulo',
		label: 'Artículo'
	},
	{
		value: 'codigo',
		label: 'Código'
	},
	{
		value: 'serie',
		label: 'Numero de serie'
	},
	{
		value: 'registrado',
		label: 'Registrado por'
	}
]

const WharehouseInventoryFiltersGeneral = ({ form }) => {
	return (
		<>
			<Form form={form} name='form-inventory-filter-general'>
				<Row gutter={16}>
					<Col span={6}>
						<Form.Item name='texto'>
							<Input autoComplete='off' placeholder='Ingresar texto...' />
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='tipo'>
							<Select
								options={fields}
								placeholder='Filtrar por...'
								allowClear
							/>
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='estado'>
							<Select options={[]} placeholder='Estado' allowClear />
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</>
	)
}

export default WharehouseInventoryFiltersGeneral
