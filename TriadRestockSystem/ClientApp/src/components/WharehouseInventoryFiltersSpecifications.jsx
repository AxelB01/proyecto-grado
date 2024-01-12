import { Col, Form, Row, Select } from 'antd'

const WharehouseInventoryFiltersSpecifications = ({
	form,
	brands,
	families
}) => {
	return (
		<>
			<Form form={form} name='form-inventory-filter-specifications'>
				<Row gutter={16}>
					<Col span={6}>
						<Form.Item name='marca'>
							<Select
								showSearch
								optionFilterProp='label'
								options={brands}
								placeholder='Marca'
								allowClear
							/>
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='familia'>
							<Select
								showSearch
								optionFilterProp='label'
								options={families}
								placeholder='Familia'
								allowClear
							/>
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</>
	)
}

export default WharehouseInventoryFiltersSpecifications
