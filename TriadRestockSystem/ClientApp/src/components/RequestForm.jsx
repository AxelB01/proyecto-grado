import {
	DownloadOutlined,
	MinusCircleOutlined,
	PlusOutlined
} from '@ant-design/icons'
import { Button, Col, Form, InputNumber, Row, Select } from 'antd'
import { useEffect, useState } from 'react'
import useCostCenters from '../hooks/useCostCenters'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const GET_ITEMS_LIST = '/api/solicitudes/getArticulosList'

const RequestForm = () => {
	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const axiosPrivate = useAxiosPrivate()
	const costCenters = useCostCenters()

	const [items, setItems] = useState([])
	const [selectedItems, setSelectedItems] = useState([])

	const getItemsList = async () => {
		try {
			const response = await axiosPrivate.get(GET_ITEMS_LIST)
			const data = response?.data
			setItems(data)
		} catch (error) {
			console.log(error)
		}
	}

	const handleFilterOption = (inputText, option) => {
		return option.label.toLowerCase().indexOf(inputText.toLowerCase()) !== -1
		// return option.children.toLowerCase().indexOf(inputText.toLowerCase()) !== -1
	}

	const onFinish = values => {
		console.log('Finish!', values)
	}

	const onFinishFailed = values => {
		console.log('Failed!', values)
	}

	useEffect(() => {
		console.log(values)
	}, [values])

	useEffect(() => {
		getItemsList()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return (
		<div>
			<Form
				form={form}
				name='form_request'
				layout='vertical'
				requiredMark={false}
			>
				<Row gutter={16}>
					<Col span={12}>
						<Form.Item
							name='centroCostos'
							label='Centro de costos'
							rules={[
								{
									required: true,
									message: 'Debe seleccionar un Centro de Costos'
								}
							]}
							hasFeedback
						>
							<Select
								showSearch
								filterOption={handleFilterOption}
								placeholder='Seleccionar'
								options={costCenters.map(costCenter => {
									return { value: costCenter.key, label: costCenter.text }
								})}
							></Select>
						</Form.Item>
					</Col>
				</Row>
				<Row gutter={16}>
					<Col span={9}>
						<Form.Item
							name='catalogo'
							label='Catálogo de artículos'
							rules={[
								{
									required: false
								}
							]}
						>
							<Select
								showSearch
								filterOption={handleFilterOption}
								placeholder='Seleccionar'
								disabled
							></Select>
						</Form.Item>
					</Col>
					<Col span={3} style={{ marginTop: '1.85rem' }}>
						<Button icon={<DownloadOutlined />}> Cargar</Button>
					</Col>
				</Row>
				<Row gutter={16}>
					<Col span={12}>
						<Form.List
							name='articulos'
							rules={[
								{
									validator: async (_, articulos) => {
										if (!articulos || articulos.length === 0) {
											return Promise.reject(
												new Error('Debe ingresar por lo menos un artículo')
											)
										}
									}
								}
							]}
						>
							{(fields, { add, remove }, { errors }) => (
								<>
									{fields.map((field, index) => (
										<div
											key={field.key}
											style={{
												display: 'flex',
												width: '100%'
											}}
										>
											<Form.Item
												name={[field.name, 'test']}
												style={{
													flex: 1
												}}
												label={index === 0 ? 'Artículos' : ''}
												required={false}
											>
												<div
													style={{
														display: 'flex',
														justifyContent: 'space-between'
													}}
												>
													<Form.Item
														name={[field.name, 'articulo']}
														{...field}
														key={field.key}
														validateTrigger={['onChange', 'onBlur']}
														rules={[
															{
																required: true,
																whitespace: true,
																message:
																	'Seleccione un artículo o elimine este campo'
															}
														]}
														noStyle
													>
														<>
															<Select
																name={[field.name, 'nombre']}
																showSearch
																filterOption={handleFilterOption}
																notFoundContent='No se encontró ningún registro'
																placeholder='Seleccionar artículo'
																style={{
																	marginRight: '2rem'
																}}
																options={items?.map(item => {
																	return {
																		value: item.value,
																		label: item.text
																	}
																})}
															></Select>
															<InputNumber
																name={[field.name, 'cantidad']}
																min={1}
																defaultValue={1}
																style={{
																	marginRight: '1rem'
																}}
															/>
														</>
													</Form.Item>
													{fields.length > 1 ? (
														<MinusCircleOutlined
															onClick={() => remove(field.name)}
														/>
													) : null}
												</div>
											</Form.Item>
										</div>
									))}

									<div
										style={{
											display: 'flex',
											justifyContent: 'center'
										}}
									>
										<Button
											type='dashed'
											style={{
												width: '80%'
											}}
											onClick={() => add()}
											icon={<PlusOutlined />}
										>
											Agregar artículo
										</Button>
									</div>

									<Row gutter={16}>
										<Col span={12}>
											<Form.ErrorList errors={errors} />
										</Col>
									</Row>
								</>
							)}
						</Form.List>
					</Col>
				</Row>
			</Form>
		</div>
	)
}

export default RequestForm
