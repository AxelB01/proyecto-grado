import {
	CheckOutlined,
	DeleteOutlined,
	DownloadOutlined,
	LoadingOutlined,
	MinusCircleOutlined,
	PlusOutlined,
	QuestionCircleOutlined,
	SaveOutlined,
	SendOutlined
} from '@ant-design/icons'
import {
	Button,
	Col,
	Form,
	Input,
	InputNumber,
	Popconfirm,
	Row,
	Select,
	Spin,
	Tag
} from 'antd'
import { useContext, useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createRequestModel } from '../functions/constructors'
import { sleep } from '../functions/sleep'
import { isObjectNotEmpty, isStringEmpty } from '../functions/validation'
import useCatalogs from '../hooks/useCatalogs'
import useCostCenters from '../hooks/useCostCenters'
import useItems from '../hooks/useItems'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import '../styles/Request.css'

const antIcon = (
	<LoadingOutlined
		style={{
			fontSize: 46
		}}
		spin
	/>
)

const GET_SINGLE_REQUEST = 'api/solicitudes/getSolicitud'
const SAVE_REQUEST = 'api/solicitudes/guardarSolicitud'
const SEND_REQUEST = 'api/solicitudes/enviarSolicitud'
const APPROVE_REQUEST = 'api/solicitudes/aprobarSolicitud'

const Request = () => {
	const location = useLocation()
	const navigate = useNavigate()
	const [customState, setCustomState] = useState(null)

	const { validLogin } = useContext(AuthContext)
	const { handleLayout, handleBreadcrumb, openMessage } =
		useContext(LayoutContext)

	const [edit, setEdit] = useState(
		customState !== undefined && customState !== null
	)
	const [viewModel, setViewModel] = useState({})
	const [loading, setLoading] = useState(
		customState !== undefined && customState !== null
	)
	const [requestCode, setRequestCode] = useState('Nueva solicitud')
	const [requestState, setRequestState] = useState('')

	const axiosPrivate = useAxiosPrivate()
	const costCenters = useCostCenters()
	const items = useItems()
	const catalogs = useCatalogs().items

	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const [saving, setSaving] = useState(false)

	const [sending, setSending] = useState(false)
	const [approving, setApproving] = useState(false)

	const [selectedItems, setSelectedItems] = useState([])
	const [availableItems, setAvailableItems] = useState([])

	const loadRequest = async () => {
		let breadcrumbLastItemText = 'Nueva solicitud'

		const breadcrumbItems = [
			{
				title: (
					<a onClick={() => navigate('/requests')}>
						<span className='breadcrumb-item'>
							{/* <SolutionOutlined /> */}
							<span className='breadcrumb-item-title'>Solicitudes</span>
						</span>
					</a>
				)
			}
		]

		if (customState !== undefined && customState !== null) {
			try {
				const response = await axiosPrivate.get(
					GET_SINGLE_REQUEST + `?id=${customState}`
				)
				if (response?.status === 200) {
					const data = response.data

					const model = createRequestModel()
					model.IdSolicitud = data.idSolicitud
					model.IdCentroCosto = data.idCentroCosto
					model.CentroCosto = data.centroCosto
					model.Numero = data.numero
					model.Justificacion = data.justificacion
					model.Notas = data.notas
					model.Fecha = data.fecha
					model.IdEstado = data.idEstado
					model.Estado = data.estado
					model.IdCreadoPor = data.idCreadoPor
					model.CreadoPor = data.creadoPor
					model.Detalles = data.detalles

					setViewModel(model)

					breadcrumbLastItemText = data.numero
					setRequestCode(`Solicitud de materiales (${data.numero})`)
					setRequestState(data.estado)
				}
			} catch (error) {
				console.log(error)
			}
		}

		breadcrumbItems.push({
			title: (
				<a>
					<span className='breadcrumb-item'>{breadcrumbLastItemText}</span>
				</a>
			)
		})
		handleBreadcrumb(breadcrumbItems)
	}

	const saveRequest = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_REQUEST, model)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud guardada correctamente')
				setCustomState(null)
				navigate(location.pathname, { state: response.data })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setSaving(false)
		}
	}

	const sendRequest = async () => {
		try {
			setSending(true)
			const id = values.idSolicitud
			const response = await axiosPrivate.post(SEND_REQUEST, id)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud enviada')
				setCustomState(null)
				navigate(location.pathname, { state: id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setSending(false)
		}
	}

	const approveRequest = async () => {
		try {
			setApproving(true)
			const id = values.idSolicitud
			const response = await axiosPrivate.post(APPROVE_REQUEST, id)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud aprobada')
				setCustomState(null)
				navigate(location.pathname, { state: id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setApproving(false)
		}
	}

	const handleCatalogLoad = () => {
		const id = form.getFieldValue('catalogo')
		const idCatalogItems = catalogs.filter(c => c.key === id)[0].items

		let formSelectedItems = form.getFieldValue('articulos')
		const idFormSelectedItems = []

		if (formSelectedItems != null) {
			formSelectedItems.forEach(item => {
				if (item.articulo.value === undefined) {
					idFormSelectedItems.push(item.articulo)
				}
				idFormSelectedItems.push(item.articulo.value)
			})
		} else {
			formSelectedItems = []
		}

		const idItemsToLoad = idCatalogItems.filter(
			i => !idFormSelectedItems.includes(i)
		)
		const itemsToLoad = items.items.filter(item =>
			idItemsToLoad.includes(item.key)
		)

		itemsToLoad.forEach(item => {
			const element = {
				articulo: {
					value: item.key,
					label: item.text
				},
				cantidad: 1,
				existencia: item.stock
			}

			formSelectedItems.push(element)
		})

		form.setFieldsValue({
			articulos: formSelectedItems
		})

		setSelectedItems(
			formSelectedItems.map(item => {
				if (item.articulo.value === undefined) {
					return item.articulo
				}
				return item.articulo.value
			})
		)

		form.resetFields(['catalogo'])
	}

	const handleFilterOption = (inputText, option) => {
		return option.label.toLowerCase().indexOf(inputText.toLowerCase()) !== -1
	}

	const handleSelectChange = (index, value) => {
		const existencia = items.items.filter(e => e.key === value)[0].stock
		const formData = form.getFieldsValue()
		formData.articulos[index].existencia = existencia
	}

	const handleSubmit = () => {
		setSaving(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createRequestModel()
		model.IdSolicitud =
			values.idSolicitud === undefined ? 0 : values.idSolicitud
		model.IdCentroCosto = values.centroCostos
		model.Justificacion = values.justificacion
		model.Notas = isStringEmpty(values.notas) ? '' : values.notas
		model.Detalles = values.articulos.map(articulo => {
			return {
				IdArticulo:
					articulo.articulo.value === undefined
						? articulo.articulo
						: articulo.articulo.value,
				Articulo: '',
				Cantidad: articulo.cantidad === undefined ? 1 : articulo.cantidad
			}
		})

		saveRequest(model)
	}

	const onFinishFailed = values => {
		setSaving(false)
		console.log('Failed!', values)
	}

	useEffect(() => {
		const { state } = location
		setCustomState(state)

		setEdit(state !== undefined && state !== null)

		document.title = 'Solicitud'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [location])

	useEffect(() => {
		loadRequest()
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [customState])

	useEffect(() => {
		if (isObjectNotEmpty(viewModel)) {
			const { Detalles, IdCentroCosto, IdSolicitud, Justificacion, Notas } =
				viewModel
			const articulos = Detalles.map(detalle => {
				return {
					articulo: {
						value: detalle.idArticulo,
						label: detalle.articulo
					},
					cantidad: detalle.cantidad,
					existencia: detalle.existencia
				}
			})
			form.setFieldsValue({
				centroCostos: IdCentroCosto,
				idSolicitud: IdSolicitud,
				justificacion: Justificacion,
				notas: Notas,
				articulos
			})

			setSelectedItems(
				Detalles.map(detalle => {
					return detalle.idArticulo
				})
			)

			setLoading(false)
		}
	}, [form, viewModel])

	useEffect(() => {
		if (values !== undefined) {
			const selectedItems = values.articulos
				?.map((e, i) => {
					const itemValue = parseInt(edit ? e?.articulo.value : e?.articulo)
					if (isNaN(itemValue)) {
						return null
					}
					return itemValue
				})
				.filter(e => e !== null)

			setSelectedItems(selectedItems)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [items, values])

	useEffect(() => {
		if (items !== undefined && selectedItems !== undefined) {
			setAvailableItems(
				items?.items?.filter(e => !selectedItems.includes(e.key))
			)
		}
	}, [items, selectedItems])

	return (
		<>
			{edit && loading ? (
				<div
					style={{
						display: 'flex',
						alignItems: 'center',
						justifyContent: 'center',
						height: '100%'
					}}
				>
					<Spin indicator={antIcon} />
				</div>
			) : (
				<div className='page-content-container'>
					<div className='content-header'>
						<div style={{ display: 'flex', flexDirection: 'row' }}>
							<span className='title'>{requestCode}</span>
							{isStringEmpty(requestState) ? (
								''
							) : (
								<>
									<Tag
										style={{
											display: 'flex',
											alignItems: 'center',
											marginLeft: '1rem'
										}}
										color={
											requestState === 'Borrador'
												? 'geekblue'
												: requestState === 'En proceso'
												? 'yellow'
												: requestState === 'Aprobado'
												? 'green'
												: 'volcano'
										}
									>
										{requestState.toUpperCase()}
									</Tag>
								</>
							)}
						</div>
						<div>
							{requestState !== 'Aprobado' ? (
								<Button
									icon={<SaveOutlined />}
									type='primary'
									loading={saving}
									disabled={saving}
									onClick={handleSubmit}
								>
									Guardar
								</Button>
							) : (
								''
							)}
							{edit && requestState !== 'Aprobado' ? (
								<>
									{requestState === 'Borrador' ? (
										<>
											<Popconfirm
												title='Enviar solicitud'
												description='¿Desea enviar esta solicitud?'
												onConfirm={sendRequest}
												onCancel={() => {}}
												okText='Enviar'
												cancelText='Cancelar'
											>
												<Button
													style={{ marginLeft: '0.95rem' }}
													icon={<SendOutlined />}
													loading={sending}
													disabled={sending}
												>
													Enviar
												</Button>
											</Popconfirm>
										</>
									) : (
										<>
											<Popconfirm
												title='Aprobar solicitud'
												description='¿Desea aprobar esta solicitud?'
												onConfirm={approveRequest}
												onCancel={() => {}}
												okText='Aprobar'
												cancelText='Cancelar'
											>
												<Button
													style={{ marginLeft: '0.95rem' }}
													icon={<CheckOutlined />}
													loading={approving}
													disabled={approving}
												>
													Aprobar
												</Button>
											</Popconfirm>
										</>
									)}
									<Popconfirm
										placement='topLeft'
										title='Descartar solicitud'
										description='¿Desea descartar esta solicitud?'
										icon={<QuestionCircleOutlined style={{ color: 'red' }} />}
										onConfirm={() => {}}
										onCancel={() => {}}
										okText='Eliminar'
										cancelText='Cancelar'
									>
										<Button
											type='primary'
											style={{ marginLeft: '0.95rem' }}
											icon={<DeleteOutlined />}
											danger
										>
											Descartar
										</Button>
									</Popconfirm>
								</>
							) : (
								''
							)}
						</div>
					</div>
					<div
						className='body-container'
						style={{ display: 'flex', flex: '1', flexDirection: 'column' }}
					>
						<div>
							<Form
								form={form}
								name='form_request'
								layout='vertical'
								onFinish={onFinish}
								onFinishFailed={onFinishFailed}
								requiredMark={false}
							>
								<Form.Item
									name='idSolicitud'
									style={{
										display: 'none'
									}}
								>
									<Input type='hidden' />
								</Form.Item>

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
											hasFeedback={!edit}
										>
											<Select
												showSearch
												filterOption={handleFilterOption}
												placeholder='Seleccionar'
												options={costCenters.map(costCenter => {
													return {
														value: costCenter.key,
														label: costCenter.text
													}
												})}
												disabled={edit}
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
												allowClear
												filterOption={handleFilterOption}
												placeholder='Seleccionar'
												options={catalogs?.map(x => {
													return { value: x.key, label: x.text }
												})}
												disabled={values?.centroCostos === undefined}
											></Select>
										</Form.Item>
									</Col>
									<Col span={3} style={{ marginTop: '1.85rem' }}>
										<Button
											icon={<DownloadOutlined />}
											onClick={handleCatalogLoad}
											disabled={
												values?.centroCostos === undefined ||
												requestState === 'Aprobado'
											}
										>
											{' '}
											Cargar
										</Button>
									</Col>
								</Row>
								<Row gutter={8}>
									<Col span={13}>
										<Form.List
											name='articulos'
											rules={[
												{
													validator: async (_, articulos) => {
														if (!articulos || articulos.length === 0) {
															return Promise.reject(
																new Error(
																	'Debe agregar por lo menos un artículo'
																)
															)
														}
													}
												}
											]}
										>
											{(fields, { add, remove }, { errors }) => (
												<>
													{values !== undefined &&
													values.articulos !== undefined ? (
														<div
															style={{
																marginBottom: '0.5rem'
															}}
														>
															<span>Artículos</span>
														</div>
													) : (
														''
													)}
													{fields.map(({ key, name, ...restFields }, index) => (
														<div
															key={key}
															style={{
																display: 'flex',
																width: '100%',
																justifyContent: 'space-between',
																alignItems: 'baseline'
															}}
														>
															<Form.Item
																name={[name, 'articulo']}
																{...restFields}
																rules={[
																	{
																		required: true,
																		message:
																			'Debe seleccionar un artículo o eliminar este elemento'
																	}
																]}
																style={{
																	// width: '50%',
																	display: 'flex',
																	flexDirection: 'row',
																	justifyContent: 'space-between'
																}}
															>
																<Select
																	showSearch
																	popupMatchSelectWidth={false}
																	filterOption={handleFilterOption}
																	placeholder='Seleccionar artículo'
																	notFoundContent='No se encontró ningún artículo'
																	onChange={value =>
																		handleSelectChange(index, value)
																	}
																	options={availableItems?.map(item => {
																		return {
																			value: item.key,
																			label: item.text
																		}
																	})}
																	style={{
																		minWidth: '23rem'
																	}}
																/>
															</Form.Item>
															<Form.Item
																name={[name, 'existencia']}
																style={{
																	display: 'flex',
																	flexDirection: 'row',
																	justifyContent: 'center'
																}}
															>
																<InputNumber
																	value={form.getFieldValue([
																		name,
																		'existencia'
																	])}
																	disabled
																/>
															</Form.Item>
															<Form.Item
																name={[name, 'cantidad']}
																{...restFields}
															>
																<InputNumber min={1} defaultValue={1} />
															</Form.Item>
															{fields.length > 1 &&
															requestState !== 'Aprobado' ? (
																<MinusCircleOutlined
																	onClick={() => remove(name)}
																/>
															) : null}
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
															disabled={values?.centroCostos === undefined}
														>
															Agregar artículo
														</Button>
													</div>

													<Row gutter={16}>
														<Col span={12}>
															<Form.ErrorList
																className='custom-form-item'
																errors={errors}
															/>
														</Col>
													</Row>
												</>
											)}
										</Form.List>
									</Col>
								</Row>
								<Row
									gutter={16}
									style={{
										marginTop: '1.5rem'
									}}
								>
									<Col span={10}>
										<Form.Item
											// style={{
											// 	width: '80%'
											// }}
											name='justificacion'
											label='Justificación'
											rules={[
												{
													required: true,
													message:
														'Debe dar una justificación para esta solicitud'
												}
											]}
											hasFeedback
										>
											<Input.TextArea rows={3} showCount maxLength={200} />
										</Form.Item>
									</Col>
									<Col span={10}>
										<Form.Item
											name='notas'
											label='Notas'
											rules={[
												{
													required: false
												}
											]}
										>
											<Input.TextArea rows={3} showCount maxLength={500} />
										</Form.Item>
									</Col>
								</Row>
							</Form>
						</div>
					</div>
				</div>
			)}
		</>
	)
}

export default Request
