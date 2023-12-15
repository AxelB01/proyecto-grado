import { Button, Col, Empty, Form, Modal, Row, Transfer } from 'antd'
import { useContext, useEffect, useState } from 'react'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createCatalogDetailsModel } from '../functions/constructors'
import { userHasAccessToModule } from '../functions/validation'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const MODULE = 'Catálogos de artículos'

const SAVE_CATALOG_COST_CENTERS = '/api/catalogos/guardarCatalogoCentrosCostos'

const customLocale = {
	itemUnit: 'centro de costo',
	itemsUnit: 'centros de costo',
	searchPlaceholder: 'Buscar',
	titles: ['Fuente', 'Catálogo'],
	notFoundContent: (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)
}

const CatalogsCostCentersForm = ({
	initialValues,
	source,
	open,
	handleOpen
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { roles } = useContext(AuthContext)
	const { openMessage } = useContext(LayoutContext)
	const [title, setTitle] = useState('')
	const [form] = Form.useForm()
	// const values = Form.useWatch([], form)

	const [loading, setLoading] = useState(false)

	const handleLoading = value => {
		setLoading(value)
	}

	const [targetKeys, setTargetKeys] = useState([])
	const [selectedKeys, setSelectedKeys] = useState([])

	const handleCancel = () => {
		handleOpen(false)
		form.resetFields()
		handleLoading(false)
	}

	const filterOption = (inputValue, option) =>
		option.shortText.indexOf(inputValue) > -1

	const onSelectChange = (sourceSelectedKeys, targetSelectedKeys) => {
		setSelectedKeys([...sourceSelectedKeys, ...targetSelectedKeys])
	}

	useEffect(() => {
		const { Id, Nombre, IdsCentrosCostos } = initialValues
		form.setFieldsValue({
			id: Id,
			centrosCostos: IdsCentrosCostos
		})
		setTargetKeys(IdsCentrosCostos)
		setTitle(`Listado de centros de costo - ${Nombre}`)
	}, [form, initialValues, open])

	const saveCatalogCostsCenters = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_CATALOG_COST_CENTERS, model)
			if (response?.status === 200) {
				openMessage('success', 'Centros de costo guardados')
				form.resetFields()
			}
		} catch (error) {
			console.log(error)
		} finally {
			handleCancel()
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createCatalogDetailsModel()
		model.Id = values.id
		model.IdsCentrosCostos = values.centrosCostos
		console.log(model)
		saveCatalogCostsCenters(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const validateTargetKeys = (rule, value, callback) => {
		if (!value || value.length === 0) {
			// eslint-disable-next-line n/no-callback-literal
			callback('Debe seleccionar por lo menos un centro de costo')
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
					name='catalog_form_costCenters'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='id'>
						<input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='centrosCostos'
								label='Selecciona los centros de costo para el catálogo'
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

export default CatalogsCostCentersForm
