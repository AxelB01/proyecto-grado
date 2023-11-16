import { DeleteOutlined } from '@ant-design/icons'
import { Button, Form, Tabs } from 'antd'
import WharehouseInventoryFiltersGeneral from './WharehouseInventoryFiltersGeneral'
import WharehouseInventoryFiltersOthers from './WharehouseInventoryFiltersOthers'
import WharehouseInventoryFiltersSpecifications from './WharehouseInventoryFiltersSpecifications'

const WharehouseInventoryFilters = () => {
	const [formGeneral] = Form.useForm()
	const [formSpecifications] = Form.useForm()
	const [formOthers] = Form.useForm()

	const resetFields = () => {
		formGeneral.resetFields()
		formSpecifications.resetFields()
		formOthers.resetFields()
	}

	const operation = (
		<Button icon={<DeleteOutlined />} onClick={resetFields}>
			Limpiar filtros
		</Button>
	)

	const items = [
		{
			key: '1',
			label: 'General',
			children: <WharehouseInventoryFiltersGeneral form={formGeneral} />
		},
		{
			key: '2',
			label: 'Especificación',
			children: (
				<WharehouseInventoryFiltersSpecifications form={formSpecifications} />
			)
		},
		{
			key: '3',
			label: 'Otros',
			children: <WharehouseInventoryFiltersOthers form={formOthers} />
		}
	]

	return (
		<>
			<Tabs tabBarExtraContent={operation} defaultActiveKey='1' items={items} />
		</>
	)
}

export default WharehouseInventoryFilters
