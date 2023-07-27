import { SearchOutlined } from '@ant-design/icons'
import { Button, Empty, Input, Space, Table } from 'antd'
import locale from 'antd/lib/locale/es_ES'
import moment from 'moment'
import { useRef } from 'react'

const CustomSimpleTable = ({ tableKey, tableRef, data, columns }) => {
	const customNoDataText = (
		<Empty
			image={Empty.PRESENTED_IMAGE_SIMPLE}
			description='No existen registros'
		/>
	)

	// Custom Filter

	const searchInput = useRef(null)
	const handleSearch = (selectedKeys, confirm, dataIndex) => {
		confirm()
	}

	const handleReset = (clearFilters, confirm) => {
		clearFilters()
		confirm()
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
		}
	})

	// Custom Filter

	// Add Custom Filters

	const customColumns = columns.map(column => {
		let customColumn = {}
		switch (column.filterType) {
			case 'text search':
				customColumn = { ...column, ...getColumnSearchProps(column.key) }
				break
			case 'custom filter':
				customColumn = {
					...column,
					filters: column.data.map(i => {
						return { text: i.text, value: i.text }
					}),
					onFilter: (value, record) => record[column.key].indexOf(value) === 0
				}
				break
			case 'date sorter':
				customColumn = {
					...column,
					sorter: (a, b) =>
						moment(a[column.key], column.dateFormat).unix() -
						moment(b[column.key], column.dateFormat).unix(),
					sortDirections: ['ascend', 'descend']
				}
				break
			default:
				customColumn = { ...column }
				break
		}
		return customColumn
	})

	// Add Custom Filters

	return (
		<>
			<Table
				key={tableKey}
				ref={tableRef}
				dataSource={data}
				columns={customColumns}
				scroll={{
					x: 1500,
					y: 500
				}}
				pagination={{
					total: data.length,
					showTotal: () => `${data.length} registros en total`,
					locale: locale.Pagination
				}}
				locale={{
					emptyText: customNoDataText
				}}
			/>
		</>
	)
}

export default CustomSimpleTable
