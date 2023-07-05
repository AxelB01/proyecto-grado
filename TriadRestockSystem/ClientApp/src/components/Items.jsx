import {

	SearchOutlined
} from '@ant-design/icons'
import { Button, Input, Space, Table } from 'antd'
import { useEffect,useState,useRef } from 'react'
import useAxiosPrivate from '../hooks/usePrivateAxios'
import Highlighter from 'react-highlight-words'
// import ItemsForm from './ItemsFrom'

const ITEMS_DATA_URL = '/api/articulos/getItemsData'
// const GET_ITEMS_DATA = '/api/articulos/getItemData'

const Items = () => {

    //const [title, setTitle] = useState('')
    const axiosPrivate = useAxiosPrivate()
    const [data, setData] = useState([])
    //const [open, setOpen] = useState(false)
	//const [loading, setLoading] = useState(false)

	const [searchText, setSearchText] = useState('')
	const [searchColumn, setSearchedColumn] = useState('')
	const searchInput = useRef(null)

	const handleSearch = (selectedKeys, confirm, dataIndex) => {
		confirm()
		setSearchText(selectedKeys[0])
		setSearchedColumn(dataIndex)
	}
	
	const handleReset = (clearFilters, confirm, dataIndex) => {
		clearFilters()
		confirm()
		setSearchText('')
		setSearchedColumn(dataIndex)
	}

	const getColumnSearchProps = dataIndex => ({
		filterDropdown: ({
			setSelectedKeys,
			selectedKeys,
			confirm,
			clearFilters,
			close
		}) => (
			<div style={{ padding: 8 }} onKeyDown={e => e.stopPropagation()}>
				<Input
					ref={searchInput}
					placeholder={`Buscar por ${dataIndex}`}
					value={selectedKeys[0]}
					onChange={e =>
						setSelectedKeys(e.target.value ? [e.target.value] : [])
					}
					onPressEnter={() => handleSearch(selectedKeys, confirm, dataIndex)}
					style={{
						marginBottom: 8,
						display: 'block'
					}}
				/>
				<Space>
					<Button
						type='primary'
						onClick={() => handleSearch(selectedKeys, confirm, dataIndex)}
						icon={<SearchOutlined />}
						size='small'
						style={{
							width: 90
						}}
					>
						Buscar
					</Button>
					<Button
						onClick={() =>
							clearFilters && handleReset(clearFilters, confirm, dataIndex)
						}
						size='small'
						style={{
							width: 90
						}}
					>
						Limpiar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							confirm({
								closeDropdown: false
							})
							setSearchText(selectedKeys[0])
							setSearchedColumn(dataIndex)
						}}
					>
						Filtrar
					</Button>
					<Button
						type='link'
						size='small'
						onClick={() => {
							close()
						}}
					>
						Cerrar
					</Button>
				</Space>
			</div>
		),
		filterIcon: filtered => (
			<SearchOutlined style={{ color: filtered ? '#1677ff' : undefined }} />
		),
		onFilter: (value, record) =>
			record[dataIndex].toString().toLowerCase().includes(value.toLowerCase()),
		onFilterDropdownOpenChange: visible => {
			if (visible) {
				setTimeout(() => searchInput.current?.select(), 100)
			}
		},
		render: text =>
			searchColumn === dataIndex ? (
				<Highlighter
					highlightStyle={{
						backgroundColor: '#ffc069',
						padding: 0
					}}
					searchWords={[searchText]}
					autoEscape
					textToHighlight={text ? text.toString() : ''}
				/>
			) : (
				text
			)
	})
	
    // const [ItemsFormInitialValues, setItemsFormInitialValues] = useState({
	// 	id: 0,
    //     idUnidadMedida: 0,
    //     codigo: 0,
    //     nombre: '',
    //     descripcion: '',
    //     familia: 0,
    //     tipoArticulo: 0,
	// })

    useEffect(() => {
		document.title = 'Articulos'
        getItemsData()
			
	}, [])
	
    const columns = [
        {
            title: 'Código',
			dataIndex: 'id',
			key: 'id',
			//...getColumnSearchProps('id')
        },
        {
            title: 'Nombre',
            dataIndex: 'nombre',
            key: 'nombre',
			//...getColumnSearchProps('nombre')

        },
        {
            title: 'Codigo de articulo',
            dataIndex: 'codigo',
            key: 'codigo',
			//...getColumnSearchProps('codigo')

        },
        {
            title: 'Unidad de Medida',
            dataIndex: 'idUnidadMedida',
            key: 'idUnidadMedida',
			//...getColumnSearchProps('idUnidadMedida')

        },
        {
            title: 'Descripcion',
            dataIndex: 'descripcion',
            key: 'descripcion',
			//...getColumnSearchProps('descripcion')

        },
        {
            title: 'Familia',
            dataIndex: 'familia',
            key: 'familia',
			//...getColumnSearchProps('familia')

        },
        {
            title: 'Tipo',
            dataIndex: 'tipo',
            key: 'tipo',
			//...getColumnSearchProps('tipo')

        },
        {
			title: 'Fecha de creación',
			dataIndex: 'fecha',
			key: 'fecha',
		},
		{
			title: 'Creado por',
			dataIndex: 'creadoPor',
			key: 'creadoPor',
			//...getColumnSearchProps('creadoPor')

		}
		// {
		// 	title: 'Acciones',
		// 	key: 'accion',
		// 	render: (_, record) => (
		// 		<Space size='middle' align='center'>
		// 			<Button
		// 				icon={<EditOutlined />}
		// 				onClick={() => handleEditItem(record)}
		// 			>
		// 				Editar
		// 			</Button>
		// 		</Space>
		// 	)
		// }
    ]

    const getItemsData = async () => {
		try {
			const response = await axiosPrivate.get(ITEMS_DATA_URL)
			const data = response?.data
			setData(data)
		} catch (error) {
			console.log(error)
		}
	}

    // const showItemsForm = () => {
	// 	setOpen(true)
	// }

	// const closeItemsForm = () => {
	// 	setOpen(false)
	// 	setLoading(false)
	// }
	
    // const handleResetItemsForm = () => {
	// 	setItemsFormInitialValues({
	// 		id: 0,
    //         idUnidadMedida: 0,
    //         codigo: 0,
    //         nombre: '',
    //         descripcion: '',
    //         familia: 0,
    //         tipoArticulo: 0,
	// 	})
	// 	setTitle('Registrar Articulo')
	// 	showItemsForm()
	// }
	// const handleEditItem = async record => {
	// 	const { key } = record
	// 	try {
	// 		const editItemUrl = `${GET_ITEMS_DATA}?id=${key}`
	// 		const respose = await axiosPrivate.get(editItemUrl)
	// 		const {
	// 			idFamilia,
	// 			familia
	// 		} = respose?.data
	// 		const model = {
	// 			id: idFamilia,
	// 			familia
	// 		}

	// 		setItemsFormInitialValues({ ...model })
	// 		setTitle('Editar articulo')
	// 		showItemsForm()
	// 	} catch (error) {
	// 		console.log(error)
	// 	}
	// }

        return (
            <>  
             {/* <ItemsForm
                title={title}
                open={open}
				onClose={closeItemsForm}
                getFamilyData={getItemsData}
				initialValues={ItemsFormInitialValues}
				loading={loading}
				handleLoading={setLoading}
            />
                <div className='btn-container'>
					<Button
						type='primary'
						icon={<UserAddOutlined />}
						onClick={handleResetItemsForm}
					>
						Nuevo Articulo
					</Button>
				</div> */}

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
        );
}
 
export default Items;