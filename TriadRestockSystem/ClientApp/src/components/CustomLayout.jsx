import { LogoutOutlined } from '@ant-design/icons'
import { Avatar, Breadcrumb, Dropdown, Layout, Menu } from 'antd'
import { useContext } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { isStringEmpty } from '../functions/validation'
import '../styles/CustomLayout.css'
import CustomFooter from './CustomFooter'
import MenuItems from './MenuItems'

const { Header, Content, Footer, Sider } = Layout

const items = [
	{
		label: (
			<a style={{ textDecoration: 'none' }}>
				<LogoutOutlined style={{ marginRight: '0.4rem' }} /> Cerrar sesión
			</a>
		),
		key: 0
	}
]

const CustomLayout = ({ children }) => {
	const { username, destroyStoredAuth } = useContext(AuthContext)
	const { active, collapsed, breadcrumb, handleSlider } =
		useContext(LayoutContext)
	const navigate = useNavigate()

	const onClick = () => {
		destroyStoredAuth()
		window.location.reload()
	}

	const handleMenuOption = e => {
		let path = ''
		const selectedKey = Number(e.key)

		switch (selectedKey) {
			case 0:
				path = '/'
				break
			case 1:
				path = '/users'
				break
			case 3:
				path = '/families'
				break
			case 4:
				path = '/items'
				break
			case 5:
				path = '/catalogs'
				break
			case 6:
				path = '/requests'
				break
			case 9:
				path = '/costsCenters'
				break
			default:
				break
		}

		navigate(path)
	}

	if (!active) {
		return <>{children}</>
	}

	return (
		<>
			<Layout style={{ minHeight: '100vh' }}>
				<Sider
					width={220}
					collapsible
					collapsed={collapsed}
					onCollapse={() => handleSlider()}
					theme='light'
				>
					<div className='logo-container'>
						<div className='logo'>
							<img src='../images/app-logo.png' />
						</div>
					</div>
					<Menu
						style={{
							width: '100%'
						}}
						defaultSelectedKeys={['0']}
						mode='inline'
						items={MenuItems}
						onClick={handleMenuOption}
					></Menu>
				</Sider>
				<Layout>
					<Header style={{ padding: 0, height: '3.5rem', background: '#FFF' }}>
						{!isStringEmpty(username) && (
							<div className='header-container'>
								<div className='user-name'>
									<span>{'uce\\' + username}</span>
								</div>
								<Dropdown menu={{ items, onClick }} trigger={['click']}>
									<a onClick={e => e.preventDefault()}>
										<Avatar
											style={{
												backgroundColor: '#1890ff',
												verticalAlign: 'middle'
											}}
											size='large'
										>
											{username[0].toUpperCase()}
										</Avatar>
									</a>
								</Dropdown>
							</div>
						)}
					</Header>
					<Content style={{ margin: '0 1rem' }}>
						<Breadcrumb style={{ margin: '1rem 0' }} items={breadcrumb} />

						<div
							style={{
								padding: 24,
								height: '95%',
								width: '100%',
								background: '#FFF'
							}}
						>
							{children}
						</div>
					</Content>
					<Footer style={{ height: 0 }}>
						<CustomFooter />
					</Footer>
				</Layout>
			</Layout>
		</>
	)
}

export default CustomLayout
