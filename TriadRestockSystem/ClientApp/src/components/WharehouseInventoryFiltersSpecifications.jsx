import { Col, Form, Input, Row, Select } from 'antd'

const WharehouseInventoryFiltersSpecifications = ({ form }) => {
	return (
		<>
			<Form form={form} name='form-inventory-filter-specifications'>
				<Row gutter={16}>
					<Col span={6}>
						<Form.Item name='marca'>
							<Select options={[]} placeholder='Marca' allowClear />
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='modelo'>
							<Input autoComplete='off' placeholder='Modelo...' />
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='familia'>
							<Select options={[]} placeholder='Familia' />
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</>
	)
}

export default WharehouseInventoryFiltersSpecifications
