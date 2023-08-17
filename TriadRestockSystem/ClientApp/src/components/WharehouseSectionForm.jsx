import { Button, Col, Form, Input, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createWharehouseSectionModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const WHAREHOUSE_SECTION_SAVE = '/api/almacenes/guardarAlmacenSeccion'

const REGEX_INPUT_LENGTH_VALIDATION = /^.{1,50}$/

const WharehouseSectionForm = ({
	initialValues,
	zonesTypes,
	wharehouseStates,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nueva sección')

	useEffect(() => {
		form.resetFields()
		const { IdAlmacen, IdSeccion, Seccion, IdTipoZona } = initialValues

		form.setFieldsValue({
			idAlm: IdAlmacen,
			idSec: IdSeccion,
			seccion: Seccion
		})

		if (IdTipoZona !== 0) {
			form.setFieldsValue({
				idTipoZona: IdTipoZona
			})
		}

		setTitle('Editar sección')

		form.setFieldsValue({
			idEstado: initialValues.IdEstado
		})

		if (IdSeccion === 0) {
			form.setFieldsValue({
				idEstado: 1
			})
			setTitle('Nueva sección')
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues])

	const saveSection = async model => {
		try {
			const response = await axiosPrivate.post(WHAREHOUSE_SECTION_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Sección guardada')
				handleLoading(false)
				handleOpen(false)
			}
		} catch (error) {
			console.log(error)
			openMessage('error', 'Error procesando la solicitud...')
			handleLoading(false)
			handleOpen(false)
		}
	}

	const handleSubmit = () => {
		handleLoading(true)
		form.submit()
	}

	const onFinish = values => {
		const model = createWharehouseSectionModel()
		model.IdAlmacen = values.idAlm
		model.IdSeccion = values.idSec
		model.Seccion = values.seccion
		model.IdTipoZona = values.idTipoZona
		model.IdEstado = values.idEstado
		saveSection(model)
	}

	const onFinishFailed = values => {
		console.log(values)
		handleLoading(false)
	}

	const handleCancel = () => {
		handleOpen(false)
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
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					name='form_wharehouse_section'
					layout='vertical'
					requiredMark
				>
					<Form.Item style={{ display: 'none' }} name='idAlm'>
						<Input type='hidden' />
					</Form.Item>
					<Form.Item style={{ display: 'none' }} name='idSec'>
						<Input type='hidden' />
					</Form.Item>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='seccion'
								label='Sección'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el nombre de la sección'
									},
									{
										pattern: REGEX_INPUT_LENGTH_VALIDATION,
										message:
											'El nombre de la sección debe tener menos de 50 caracteres'
									}
								]}
								hasFeedback
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar el nombre de la sección'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={12}>
							<Form.Item
								name='idTipoZona'
								label='Tipo de zona'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tipo de zona'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={zonesTypes?.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
						<Col span={12}>
							<Form.Item
								name='idEstado'
								label='Estado'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un estado'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={wharehouseStates?.map(x => {
										return { value: x.key, label: x.text }
									})}
								></Select>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default WharehouseSectionForm
