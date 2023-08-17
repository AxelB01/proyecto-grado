import { Button, Col, Form, Input, Modal, Row, Select } from 'antd'
import { useContext, useEffect, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createBankAccountModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const BANK_ACCOUNT_SAVE = '/api/configuraciones/guardarCuentaBanco'

const BankAccountForm = ({
	editable,
	banks,
	bankAccountTypes,
	initialValues,
	open,
	handleOpen,
	loading,
	handleLoading
}) => {
	const axiosPrivate = useAxiosPrivate()
	const { openMessage } = useContext(LayoutContext)
	const [form] = Form.useForm()

	const [title, setTitle] = useState('Nueva cuenta de banco')

	useEffect(() => {
		const { IdBanco, IdTipoCuenta, Cuenta, Descripcion } = initialValues

		setTitle('Nueva cuenta de banco')
		form.resetFields()

		if (IdBanco !== 0) {
			setTitle('Editar cuenta de banco')

			form.setFieldsValue({
				idBanco: IdBanco,
				idTipoCuenta: IdTipoCuenta,
				cuenta: Cuenta,
				descripcion: Descripcion
			})
		}
	}, [form, initialValues, open])

	const saveBankAccount = async model => {
		try {
			const response = await axiosPrivate.post(BANK_ACCOUNT_SAVE, model)
			if (response?.status === 200) {
				openMessage('success', 'Banco guardado')
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
		const model = createBankAccountModel()
		model.IdBanco = values.idBanco
		model.IdTipoCuenta = values.idTipoCuenta
		model.Cuenta = values.cuenta
		model.Descripcion = values.descripcion
		saveBankAccount(model)
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
					name='form_bank_account'
					layout='vertical'
					requiredMark
				>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='idBanco'
								label='Banco'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un banco'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={banks?.map(x => {
										return { value: x.key, label: x.text }
									})}
									disabled={!editable}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='idTipoCuenta'
								label='Tipo de cuenta'
								rules={[
									{
										required: true,
										message: 'Debe seleccionar un tipo de cuenta'
									}
								]}
								hasFeedback
							>
								<Select
									placeholder='Seleccionar'
									options={bankAccountTypes.map(x => {
										return { value: x.key, label: x.text }
									})}
									disabled={!editable}
								></Select>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='cuenta'
								label='Cuenta'
								rules={[
									{
										required: true,
										message: 'Debe ingresar el número de la cuenta'
									}
								]}
								hasFeedback
							>
								<Input
									autoComplete='off'
									placeholder='Ingresar un número de cuenta'
								/>
							</Form.Item>
						</Col>
					</Row>
					<Row gutter={16}>
						<Col span={24}>
							<Form.Item
								name='descripcion'
								label='Descripcion'
								rules={[
									{
										required: true,
										message: 'Debe ingresar una descripcion'
									}
								]}
							>
								<Input.TextArea
									placeholder='Ingresar una descripción'
									rows={3}
									showCount
									maxLength={150}
								/>
							</Form.Item>
						</Col>
					</Row>
				</Form>
			</Modal>
		</>
	)
}

export default BankAccountForm
