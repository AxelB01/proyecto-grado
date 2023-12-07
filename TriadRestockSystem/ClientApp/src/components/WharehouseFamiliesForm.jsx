import { Button, Col, Empty, Form, Input, Modal, Row, Transfer } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createWharehouseFamiliesModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const customLocale = {
	itemUnit: 'familia',
	itemsUnit: 'familias',
	searchPlaceholder: 'Buscar',
	titles: ['Fuente', 'Almacén'],
	notFoundContent: (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)
}

const SAVE_WHAREHOUSE_FAMILIES = '/api/almacenes/guardarAlmacenesFamilias'

const WharehouseFamiliesForm = ({
	open,
	toggle,
	source,
	access,
	initialValues
}) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()
	const [form] = Form.useForm()

	const [loading, setLoading] = useState(false)

	const cancel = () => {
		toggle()
		setTimeout(() => {
			setLoading(false)
		}, 100)
	}

	const validateTargetKeys = (rule, value, callback) => {
		if (!value || value.length === 0) {
			// eslint-disable-next-line n/no-callback-literal
			callback('Debe seleccionar por lo menos una familia')
		} else {
			callback()
		}
	}

	const saveWharehouseFamilies = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_WHAREHOUSE_FAMILIES, model)
			if (response?.status === 200) {
				openMessage('success', 'Familias guardadas correctamente')
			}
		} catch (error) {
			openMessage('error', 'Ha ocurrido un error inesperado')
		} finally {
			cancel()
		}
	}

	const submitForm = () => {
		setLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createWharehouseFamiliesModel()
		model.Id = values.id
		model.Families = values.detalle

		saveWharehouseFamilies(model)
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	const [targetKeys, setTargetKeys] = useState([])
	const [selectedKeys, setSelectedKeys] = useState([])

	const filterOption = (inputValue, option) =>
		option.name.indexOf(inputValue) > -1

	const onSelectChange = (sourceSelectedKeys, targetSelectedKeys) => {
		setSelectedKeys([...sourceSelectedKeys, ...targetSelectedKeys])
	}

	useEffect(() => {
		const { Id, Families } = initialValues
		form.setFieldsValue({
			id: Id,
			detalle: Families
		})
		setTargetKeys(Families)
	}, [initialValues, form])

	return (
		<>
			<Modal
				title={'Lista de familias'}
				width={900}
				open={open}
				onCancel={cancel}
				footer={[
					<Button key='back' onClick={cancel}>
						Cancelar
					</Button>,
					<Button
						key='submit'
						type='primary'
						loading={loading}
						onClick={submitForm}
						disabled={!access}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_wharehouse_families'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='detalle'
								label='Selecciona las familias para el almacén'
								rules={[
									{
										validator: validateTargetKeys
									}
								]}
							>
								<Transfer
									listStyle={{
										width: 500,
										height: 300
									}}
									locale={customLocale}
									dataSource={source}
									showSearch
									oneWay
									filterOption={filterOption}
									targetKeys={targetKeys}
									selectedKeys={selectedKeys}
									onChange={newTargetKeys => {
										setTargetKeys(newTargetKeys)
									}}
									onSelectChange={onSelectChange}
									render={item => item.text}
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default WharehouseFamiliesForm
