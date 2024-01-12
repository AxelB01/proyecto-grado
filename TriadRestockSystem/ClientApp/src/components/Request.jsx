import {
	CheckOutlined,
	ContainerOutlined,
	DeleteOutlined,
	DownloadOutlined,
	HomeOutlined,
	PlusOutlined,
	QuestionCircleOutlined,
	SaveOutlined,
	SendOutlined,
	StopOutlined
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
	Tag
} from 'antd'
import { useContext, useEffect, useState } from 'react'
import { useLocation } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { createRequestModel } from '../functions/constructors'
import {
	isObjectNotEmpty,
	isStringEmpty,
	userHasAccessToModule
} from '../functions/validation'
import useCostCenters from '../hooks/useCostCenters'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import '../styles/DefaultContentStyle.css'
import '../styles/Request.css'
import RequestRejectModal from './RequestRejectModal'

const MODULE = 'Solicitudes de materiales'

const GET_CATALOGS = 'api/solicitudes/getCatalogosList'
const GET_ITEMS = 'api/solicitudes/getArticulosList'

const GET_SINGLE_REQUEST = 'api/solicitudes/getSolicitud'
const SAVE_REQUEST = 'api/solicitudes/guardarSolicitud'
const SEND_REQUEST = 'api/solicitudes/enviarSolicitud'
const APPROVE_REQUEST = 'api/solicitudes/aprobarSolicitud'
const ARCHIVE_REQUEST = 'api/solicitudes/archivarSolicitud'

const Request = () => {
	const location = useLocation()
	const [customState, setCustomState] = useState(null)

	const { validLogin, roles } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		openMessage,
		navigateToPath
	} = useContext(LayoutContext)

	const [editable, setEditable] = useState(true)
	const [viewModel, setViewModel] = useState({})
	const [requestCode, setRequestCode] = useState('Nueva solicitud')
	const [requestState, setRequestState] = useState('')

	const axiosPrivate = useAxiosPrivate()
	const costCenters = useCostCenters()
	const [items, setItems] = useState([])
	const [catalogs, setCatalogs] = useState([])

	const [form] = Form.useForm()
	const values = Form.useWatch([], form)
	const [saving, setSaving] = useState(false)

	const [sending, setSending] = useState(false)
	const [approving, setApproving] = useState(false)
	const [archiving, setArchiving] = useState(false)

	const [selectedItems, setSelectedItems] = useState([])
	const [availableItems, setAvailableItems] = useState([])

	const [rejectModalStatus, setRejectModalStatus] = useState(false)

	const handleRejectModalStatus = () => {
		setRejectModalStatus(!rejectModalStatus)
	}

	const getCatalogs = async id => {
		try {
			const response = await axiosPrivate.get(GET_CATALOGS + `?id=${id}`)

			if (response?.status === 200) {
				const data = response.data
				setCatalogs(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const getItems = async id => {
		try {
			const response = await axiosPrivate.get(GET_ITEMS + `?id=${id}`)

			if (response?.status === 200) {
				const data = response.data
				setItems(data)
				setAvailableItems(data)
			}
		} catch (error) {
			console.log(error)
		}
	}

	const loadRequest = async () => {
		const breadcrumbItems = [
			{
				title: (
					<a onClick={() => navigateToPath('/')}>
						<span className='breadcrumb-item'>
							<HomeOutlined />
						</span>
					</a>
				)
			},
			{
				title: (
					<a onClick={() => navigateToPath('/requests')}>
						<span className='breadcrumb-item'>Solicitudes</span>
					</a>
				)
			}
		]

		let breadcrumbLastItemText = 'Nueva solicitud'

		try {
			if (customState !== undefined && customState !== null) {
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
					model.CausaRechazo = data.causaRechazo

					setViewModel(model)

					breadcrumbLastItemText = data.numero
					setRequestCode(`Solicitud de materiales (${data.numero})`)
					setRequestState(data.estado)
				}
			}
		} catch (error) {
			console.log(error)
		} finally {
			breadcrumbItems.push({
				title: (
					<a>
						<span className='breadcrumb-item'>{breadcrumbLastItemText}</span>
					</a>
				)
			})

			handleBreadcrumb(breadcrumbItems)
		}

		setTimeout(() => {
			if (validLogin !== undefined && validLogin !== null) {
				if (validLogin) {
					handleLayout(true)
				} else {
					handleLayout(false)
				}
			}
		}, 1500)

		// setTimeout(() => {
		// 	if (validLogin !== undefined && validLogin !== null) {
		// 		if (validLogin) {
		// 			handleLayout(true)
		// 			handleBreadcrumb(breadcrumbItems)
		// 		} else {
		// 			handleLayout(false)
		// 		}
		// 	}
		// }, 100)
	}

	const saveRequest = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_REQUEST, model)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud guardada correctamente')
				// setCustomState(null)
				navigateToPath(location.pathname, { Id: response.data })
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
				navigateToPath(location.pathname, { Id: id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setSending(false)
		}
	}

	const archiveRequest = async () => {
		try {
			setArchiving(true)
			const id = values.idSolicitud
			const response = await axiosPrivate.post(ARCHIVE_REQUEST, id)
			const status = response?.status
			if (status === 200) {
				openMessage('success', 'Solicitud archivada')
				setCustomState(null)
				navigateToPath(location.pathname, { Id: id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setArchiving(false)
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
				navigateToPath(location.pathname, { Id: id })
			}
		} catch (error) {
			console.log(error)
		} finally {
			setApproving(false)
		}
	}

	const reloadRequest = () => {
		const id = customState
		setCustomState(null)
		navigateToPath(location.pathname, { Id: id })
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
		const itemsToLoad = items.filter(item => idItemsToLoad.includes(item.key))

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
		const existencia = items.filter(e => e.key === value)[0].stock
		const formData = form.getFieldsValue()
		formData.articulos[index].existencia = existencia
	}

	const handleSubmit = () => {
		form.submit()
	}

	const onFinish = values => {
		setSaving(true)
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
		setCustomState(state.Id)
		setEditable(state.Id !== undefined && state.Id !== null)
		document.title = 'Solicitud'

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin, location])

	useEffect(() => {
		const interval = setInterval(() => {
			if (display) {
				handleLayoutLoading(false)
			}
		}, 200)
		return () => {
			clearInterval(interval)
		}
	}, [display, handleLayoutLoading])

	useEffect(() => {
		if (!validLogin) {
			navigateToPath('/login')
		}
	}, [validLogin, roles, navigateToPath])

	// useEffect(() => {
	// 	const { state } = location
	// 	setCustomState(state)

	// 	setEdit(state !== undefined && state !== null)

	// 	document.title = 'Solicitud'
	// 	async function waitForUpdate() {
	// 		await sleep(1000)
	// 	}

	// 	if (!validLogin) {
	// 		waitForUpdate()
	// 		handleLayout(false)
	// 		navigate('/login')
	// 	} else {
	// 		handleLayout(true)
	// 	}
	// 	// eslint-disable-next-line react-hooks/exhaustive-deps
	// }, [location])

	useEffect(() => {
		const id = values?.centroCostos
		if (id !== 0) {
			getCatalogs(id)
			getItems(id)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [values])

	useEffect(() => {
		if (customState !== undefined && customState !== null) {
			loadRequest()
		}
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
		}
	}, [form, viewModel])

	useEffect(() => {
		if (values !== undefined) {
			const selectedItems = values.articulos
				?.map((e, i) => {
					const itemValue = parseInt(editable ? e?.articulo.value : e?.articulo)
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
			setAvailableItems(items.filter(e => !selectedItems.includes(e.key)))
		}
	}, [items, selectedItems])

	return (
		<>
			<RequestRejectModal
				id={customState}
				status={rejectModalStatus}
				toggle={handleRejectModalStatus}
				reload={reloadRequest}
			/>
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
						{requestState !== 'Aprobado' && requestState !== 'Archivado' ? (
							<Button
								icon={<SaveOutlined />}
								type='primary'
								loading={saving}
								disabled={
									saving ||
									(requestState !== '' &&
										requestState !== 'Borrador' &&
										requestState !== 'Rechazado') ||
									userHasAccessToModule(MODULE, 'view', roles)
								}
								onClick={handleSubmit}
							>
								Guardar
							</Button>
						) : (
							''
						)}
						{editable &&
						requestState !== 'Aprobado' &&
						requestState !== 'Archivado' ? (
							<>
								{requestState === 'Borrador' || requestState === 'Rechazado' ? (
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
												disabled={
													sending ||
													userHasAccessToModule(MODULE, 'view', roles)
												}
											>
												Enviar
											</Button>
										</Popconfirm>
									</>
								) : userHasAccessToModule(MODULE, 'management', roles) &&
								  requestState !== '' ? (
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
												disabled={
													approving ||
													!userHasAccessToModule(MODULE, 'management', roles)
												}
											>
												Aprobar
											</Button>
										</Popconfirm>
									</>
								) : null}
								{requestState === 'En proceso' ? (
									userHasAccessToModule(MODULE, 'management', roles) ? (
										<>
											<Popconfirm
												title='Rechazar solicitud'
												description='¿Desea rechazar esta solicitud?'
												icon={
													<QuestionCircleOutlined style={{ color: 'red' }} />
												}
												onConfirm={handleRejectModalStatus}
												onCancel={() => {}}
												okText='Continuar'
												cancelText='Cancelar'
											>
												<Button
													type='primary'
													style={{ marginLeft: '0.95rem' }}
													icon={<StopOutlined />}
													disabled={
														!userHasAccessToModule(MODULE, 'management', roles)
													}
													danger
												>
													Rechazar
												</Button>
											</Popconfirm>
										</>
									) : null
								) : requestState !== '' ? (
									<>
										<Popconfirm
											title='Archivar solicitud'
											description='¿Desea archivar esta solicitud?'
											icon={<QuestionCircleOutlined style={{ color: 'red' }} />}
											onConfirm={archiveRequest}
											onCancel={() => {}}
											okText='Archivar'
											cancelText='Cancelar'
										>
											<Button
												type='primary'
												style={{ marginLeft: '0.95rem' }}
												icon={<ContainerOutlined />}
												loading={archiving}
												disabled={userHasAccessToModule(MODULE, 'view', roles)}
												danger
											>
												Archivar
											</Button>
										</Popconfirm>
									</>
								) : null}
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
										hasFeedback={!editable}
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
											disabled={!(editable && requestState === '')}
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
								<Col span={14}>
									<Form.List
										name='articulos'
										rules={[
											{
												validator: async (_, articulos) => {
													if (!articulos || articulos.length === 0) {
														return Promise.reject(
															new Error('Debe agregar por lo menos un artículo')
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
													<>
														<div
															style={{
																marginBottom: '0.5rem'
															}}
														>
															<span>Artículos</span>
														</div>
													</>
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
																value={form.getFieldValue([name, 'existencia'])}
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
															<DeleteOutlined onClick={() => remove(name)} />
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
															width: '70%'
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
											},
											{
												max: 200,
												message: 'El texto ingresado excede el límite permitido'
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
											},
											{
												max: 500,
												message: 'El texto ingresado excede el límite permitido'
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
			<div>
				{viewModel?.Estado === 'Rechazado' ? (
					<>
						<Col span={20}>
							<span style={{ fontWeight: 'bold' }}>Causa del rechazo</span>
							<br />
							<br />
							<Input.TextArea rows={3} value={viewModel?.CausaRechazo} />
							<br />
							<br />
						</Col>
					</>
				) : null}
			</div>
		</>
	)
}

export default Request
