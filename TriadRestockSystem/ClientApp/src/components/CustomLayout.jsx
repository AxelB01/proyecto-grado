import { LogoutOutlined } from '@ant-design/icons'
import { Avatar, Breadcrumb, Dropdown, Layout, Menu } from 'antd'
import { useContext } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { isStringEmpty } from '../functions/validation'
import CustomFooter from './CustomFooter'
import './CustomLayout.css'
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
	const { active, collapsed, page, handleSlider, handlePageChange } =
		useContext(LayoutContext)
	const navigate = useNavigate()

	const onClick = () => {
		destroyStoredAuth()
		window.location.reload()
	}

	const handleMenuOption = e => {
		const selectedKey = Number(e.key)
		switch (selectedKey) {
			case 0:
				handlePageChange('Inicio')
				navigate('/')
				break
			case 1:
				handlePageChange('Usuarios')
				navigate('/users')
				break
			case 6:
				handlePageChange('Solicitudes')
				navigate('/requests')
				break
			default:
				break
		}
	}

	if (!active) {
		return <>{children}</>
	}

	return (
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
											backgroundColor: '#40a9ff',
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
					<Breadcrumb
						style={{ margin: '1rem 0' }}
						items={[
							{
								title: <span className='page-name'>{page}</span>
							}
						]}
					/>

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
	)
}

export default CustomLayout
