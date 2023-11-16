import { Col, DatePicker, Form, Row, Select } from 'antd'
import locale from 'antd/lib/date-picker/locale/es_ES'

const { RangePicker } = DatePicker

const WharehouseInventoryFiltersOthers = ({ form }) => {
	return (
		<>
			<Form form={form} name='form-inventory-filter-other'>
				<Row gutter={16}>
					<Col span={6}>
						<Form.Item name='seccion'>
							<Select options={[]} placeholder='Sección' allowClear />
						</Form.Item>
					</Col>
					<Col span={6}>
						<Form.Item name='estantería'>
							<Select options={[]} placeholder='Estantería' allowClear />
						</Form.Item>
					</Col>
					<Col span={8}>
						<Form.Item name='registro'>
							<RangePicker
								locale={locale}
								allowClear
								allowEmpty={[true, true]}
							/>
						</Form.Item>
					</Col>
				</Row>
			</Form>
		</>
	)
}

export default WharehouseInventoryFiltersOthers
