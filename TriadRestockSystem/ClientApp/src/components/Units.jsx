import { HomeOutlined } from '@ant-design/icons'
import { Tabs } from 'antd'
import { useContext, useEffect } from 'react'
import UnitType from '../components/TypesForms/UnitType'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import ItemsType from './TypesForms/ItemsType'

const Units = () => {
	const { validLogin } = useContext(AuthContext)
	const {
		display,
		handleLayout,
		handleLayoutLoading,
		handleBreadcrumb,
		navigateToPath
	} = useContext(LayoutContext)

	const onChange = key => {
		console.log(key)
	}

	const items = [
		{
			key: '1',
			label: `Tipo de articulos`,
			children: <ItemsType />
		},
		{
			key: '2',
			label: `Unidad de medida`,
			children: <UnitType />
		}
	]

	useEffect(() => {
		document.title = 'Unidades y Estados'

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
					<a onClick={() => {}}>
						<span className='breadcrumb-item'>Unidades y Estados</span>
					</a>
				)
			}
		]

		handleBreadcrumb([])

		if (validLogin !== undefined && validLogin !== null) {
			if (validLogin) {
				handleLayout(true)
				handleBreadcrumb(breadcrumbItems)
			}
		} else {
			handleLayout(false)
		}

		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [validLogin])

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
	}, [validLogin, navigateToPath])

	return (
		<>
			<Tabs defaultActiveKey='1' items={items} onChange={onChange} />
		</>
	)
}
export default Units
