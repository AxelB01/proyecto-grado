import { DeleteOutlined } from '@ant-design/icons'
import { Button, Form, Tabs } from 'antd'
import { useEffect } from 'react'
import WharehouseInventoryFiltersGeneral from './WharehouseInventoryFiltersGeneral'
import WharehouseInventoryFiltersOthers from './WharehouseInventoryFiltersOthers'
import WharehouseInventoryFiltersSpecifications from './WharehouseInventoryFiltersSpecifications'

const WharehouseInventoryFilters = ({ filteredData, brands, families }) => {
	const [formGeneral] = Form.useForm()
	const [formSpecifications] = Form.useForm()
	const [formOthers] = Form.useForm()

	const valuesGeneral = Form.useWatch([], formGeneral)
	const valuesSpecifications = Form.useWatch([], formSpecifications)

	useEffect(() => {
		filteredData(
			valuesGeneral?.texto,
			valuesGeneral?.tipo,
			valuesSpecifications?.marca,
			valuesSpecifications?.familia
		)
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [valuesGeneral, valuesSpecifications])

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
				<WharehouseInventoryFiltersSpecifications
					form={formSpecifications}
					brands={brands}
					families={families}
				/>
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
