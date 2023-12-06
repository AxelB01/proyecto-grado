import { Button, Checkbox, Form, Input, Modal, Table } from 'antd'
import { useContext, useEffect, useRef, useState } from 'react'
import LayoutContext from '../context/LayoutContext'
import { createRolePermissionsModel } from '../functions/constructors'
import useAxiosPrivate from '../hooks/usePrivateAxios'

const SAVE_ROLE_PERMISSIONS = '/api/configuraciones/saveRolePermissions'

const RolePermissionsForm = ({ open, toggle, initialValues }) => {
	const { openMessage } = useContext(LayoutContext)
	const axiosPrivate = useAxiosPrivate()

	const [form] = Form.useForm()
	const [loading, setLoading] = useState(false)

	const [title, setTitle] = useState('')
	const [tableKey, setTableKey] = useState(Date.now())
	const tableRef = useRef()

	const cancel = () => {
		toggle()
		setTimeout(() => {
			setTitle('')
			setTableData([])
			setLoading(false)
			setTableKey(Date.now())
		}, 150)
	}

	const saveRolePermissions = async model => {
		try {
			const response = await axiosPrivate.post(SAVE_ROLE_PERMISSIONS, model)
			if (response?.status === 200) {
				openMessage('success', 'Permisos guardados correctamente')
			}
		} catch (error) {
			console.log(error)
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
		const model = createRolePermissionsModel()
		model.IdRole = values.id
		model.Permissions = tableData.map(p => {
			return {
				Id: p.key,
				View: p.checkedValue === 'Vista',
				Creation: p.checkedValue === 'Creación',
				Management: p.checkedValue === 'Gestión'
			}
		})
		saveRolePermissions(model)
	}

	const onFinishFailed = values => {
		console.log(values)
	}

	const [tableData, setTableData] = useState([])

	const handleCheckboxChange = (rowKey, checkboxLabel) => {
		const updatedData = tableData.map(row => {
			if (row.key === rowKey) {
				return {
					...row,
					checkedValue:
						row.checkedValue === checkboxLabel ? null : checkboxLabel
				}
			}
			return row
		})
		setTableData(updatedData)
	}

	let columns = []
	if (tableData.length > 0) {
		columns = [
			{
				title: 'Description',
				dataIndex: 'description',
				key: 'description'
			},
			...tableData[0].checkboxes.map((checkbox, index) => ({
				title: checkbox.label,
				dataIndex: `checkboxes[${index}].checked`,
				key: `checkbox${index + 1}`,
				render: (_, record) => (
					<td key={index} style={{ display: 'flex', justifyContent: 'center' }}>
						<Checkbox
							checked={record.checkedValue === checkbox.label}
							onChange={() => handleCheckboxChange(record.key, checkbox.label)}
							disabled={record.disabled.includes(checkbox.label)}
							style={{
								display: record.disabled.includes(checkbox.label) ? 'none' : ''
							}}
						/>
					</td>
				)
			}))
		]
	}

	useEffect(() => {
		if (Object.keys(initialValues).length !== 0) {
			form.setFieldsValue({
				id: initialValues.Key
			})
			setTitle(`${initialValues.Role} - Permisos`)
			setTableData(initialValues.Permissions)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [initialValues])

	return (
		<>
			<Modal
				width={900}
				open={open}
				title={title}
				onCancel={cancel}
				footer={[
					<Button key='btn-cancel' onClick={cancel}>
						Cancelar
					</Button>,
					<Button
						key='btn-save'
						type='primary'
						onClick={submitForm}
						loading={loading}
					>
						Guardar
					</Button>
				]}
			>
				<Form
					form={form}
					name='form_role_permissions'
					layout='vertical'
					onFinish={onFinish}
					onFinishFailed={onFinishFailed}
					requiredMark={false}
				>
					<Form.Item name='id' style={{ display: 'none' }}>
						<Input type='hidden' />
					</Form.Item>
				</Form>
				<Table
					key={tableKey}
					ref={tableRef}
					columns={columns}
					dataSource={tableData}
					pagination={false}
					scroll={{ y: 230 }}
				/>
			</Modal>
		</>
	)
}

export default RolePermissionsForm
