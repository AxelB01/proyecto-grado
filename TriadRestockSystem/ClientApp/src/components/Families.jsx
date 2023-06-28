import {
	UserAddOutlined
} from '@ant-design/icons'
import { Table, Button} from 'antd'
import { useEffect,useState } from 'react'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import FamiliesForm from './FamiliesForm'

const FAMILIES_DATA_URL = '/api/familias/getFamilias'

const Families = () => {

    const [title, setTitle] = useState('')
    const axiosPrivate = useAxiosPrivate()
    const [data, setData] = useState([])
    const [open, setOpen] = useState(false)
	const [loading, setLoading] = useState(false)

    const [familyFormInitialValues, setFamiliesFormInitialValues] = useState({
		id: 0,
		nombre: ''
	})

    useEffect(() => {
		document.title = 'Familias'

        getFamiliesData()
			
	}, [])
    const columns = [
        {
            title: 'Código',
			dataIndex: 'id',
			key: 'id',
        },
        {
            title: 'Nombre',
            dataIndex: 'familia',
            key: 'familia',
        },
        {
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha'
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
		},
    ]

    const getFamiliesData = async () => {
		try {
			const response = await axiosPrivate.get(FAMILIES_DATA_URL)
			const data = response?.data
			console.log(data)
			setData(data)
		} catch (error) {
			console.log(error)
		}
	}

    const showFamiliesForm = () => {
		setOpen(true)
	}

	const closeFamiliesForm = () => {
		setOpen(false)
		setLoading(false)
	}
    const handleResetFamiliesForm = () => {
		setFamiliesFormInitialValues({
			id: 0,
			familia: '',
		})
		setTitle('Registrar Familia')
		showFamiliesForm()
	}

    return(
        <>
            <FamiliesForm
                title={title}
                open={open}
				onClose={closeFamiliesForm}
                getUsersData={getFamiliesData}
				initialValues={familyFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
            />
                <div className='btn-container'>
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetFamiliesForm}
					>
						Nuevo familia
					</Button>
				</div>

            <div className='table-container'>
                <Table
                    columns={columns}
                    dataSource={data}
                    pagination={{
                    total: data.length,
                    showTotal: () => `${data.length} registros en total`,
                    defaultPageSize: 10,
                    defaultCurrent: 1
                    }}
                />
            </div>
        </>
    )

}
export default Families
