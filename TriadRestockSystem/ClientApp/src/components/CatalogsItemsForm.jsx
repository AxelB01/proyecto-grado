import { Button, Col, Empty, Form, Modal, Row, Transfer } from 'antd'
import { useContext, useEffect, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCatalogItemsModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const MODULE = 'Catálogos de artículos'

const SAVE_CATALOG_ITEMS = '/api/catalogos/guardarArticulosCatalogo'

const customLocale = {
	itemUnit: 'artículo',
	itemsUnit: 'artículos',
	searchPlaceholder: 'Buscar',
	titles: ['Fuente', 'Catálogo'],
	notFoundContent: (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)
}

const CatalogsItemsForm = ({
	initialValues,
	source,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { roles } = useContext(AuthContext)
	const { openMessage } = useContext(LayoutContext)
	const [title, setTitle] = useState('')
	const [form] = Form.useForm()
	// const values = Form.useWatch([], form)

	const [targetKeys, setTargetKeys] = useState([])
	const [selectedKeys, setSelectedKeys] = useState([])

	const filterOption = (inputValue, option) =>
		option.shortText.indexOf(inputValue) > -1

	const onSelectChange = (sourceSelectedKeys, targetSelectedKeys) => {
		setSelectedKeys([...sourceSelectedKeys, ...targetSelectedKeys])
	}

	useEffect(() => {
		const { Id, Nombre, Detalle } = initialValues
		form.setFieldsValue({
			id: Id,
			detalle: Detalle
		})
		setTargetKeys(Detalle)
		setTitle(`Listado de artículos - ${Nombre}`)
	}, [form, initialValues, open])

	const saveCatalogItems = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_CATALOG_ITEMS, model)
			if (response?.status === 200) {
				openMessage('success', 'Artículos guardados')
				handleLoading(false)
				handleOpen(false)
				form.resetFields()
			}
		} catch (error) {
			console.log(error)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createCatalogItemsModel()
		model.Id = values.id
		model.Detalle = values.detalle
		console.log(model)
		saveCatalogItems(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleOpen(false)
		form.resetFields()
	}

	const validateTargetKeys = (rule, value, callback) => {
		if (!value || value.length === 0) {
			// eslint-disable-next-line n/no-callback-literal
			callback('Debe seleccionar por lo menos un artículo')
		} else {
			callback()
		}
	}

	return (
		<>
			<Modal
				title={title}
				open={open}
				onOk={handleSubmit}
				onCancel={handleCancel}
				footer={[
					<Button key='back' onClick={handleCancel}>
						Cancelar
					</Button>,
					<Button
						key='submit'
						type='primary'
						loading={loading}
						onClick={handleSubmit}
						disabled={!userHasAccessToModule(MODULE, 'creation', roles)}
					>
						Guardar
					</Button>
				]}
				width={800}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_catalog_items'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='detalle'
								label='Selecciona los artículos para el catálogo'
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
									render={item => item.shortText}
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default CatalogsItemsForm
