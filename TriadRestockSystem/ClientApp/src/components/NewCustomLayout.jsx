import { LogoutOutlined } from '@ant-design/icons'
import { Avatar, Breadcrumb, Dropdown, Layout, Menu } from 'antd'
import Animate from 'rc-animate'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import Loader from './Loader'
import MenuItems from './MenuItems'

const { Header, Content, Sider } = Layout

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

const NewCustomLayout = ({ children }) => {
	const { destroyStoredAuth } = useContext(AuthContext)
	const { active, collapsed, breadcrumb, handleSlider } =
		useContext(LayoutContext)
	const navigate = useNavigate()
	const [isSiderFixed, setIsSiderFixed] = useState(false)

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
			case 2:
				path = '/wharehouses'
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
			case 10:
				path = '/suppliers'
				break
			default:
				break
		}

		navigate(path)
	}

	useEffect(() => {
		const handleScroll = () => {
			const scrollTop = window.scrollY || document.documentElement.scrollTop
			setIsSiderFixed(scrollTop >= 65)
		}

		window.addEventListener('scroll', handleScroll)

		return () => {
			window.removeEventListener('scroll', handleScroll)
		}
	}, [])

	if (active == null) {
		return (
			<>
				<Loader />
			</>
		)
	}

	if (!active) {
		return <>{children}</>
	}

	return (
		<Layout style={{ minHeight: '100vh' }}>
			<Header
				className='site-layout-background'
				style={{
					padding: 0,
					background: '#fff',
					borderBottom: '1px solid #f0f0f0'
				}}
			>
				<div
					className='logo-container'
					style={{
						display: 'flex',
						justifyContent: 'start',
						alignItems: 'center',
						maxWidth: '100%',
						// minHeight: '3rem',
						padding: '0rem 0rem 0rem 0rem'
					}}
				>
					<div
						className='logo'
						style={{
							display: 'flex',
							justifyContent: 'start',
							alignItems: 'center',
							width: '12rem',
							minHeight: 'auto'
						}}
					>
						<img
							src='../images/triad-restock-2-copy.png'
							style={{
								width: '100%',
								height: 'auto'
							}}
						/>
					</div>
					<Animate showProp='visible' transitionName='fade'>
						{!collapsed ? (
							<div
								style={{
									height: '2.8rem',
									width: 'auto',
									marginLeft: '0.42rem',
									borderRight: '0.12rem solid #d9d9d9'
								}}
							></div>
						) : null}
					</Animate>

					<div
						style={{
							flex: 1,
							display: 'flex',
							justifyContent: 'end',
							paddingRight: '1rem'
						}}
					>
						<Dropdown menu={{ items, onClick }} trigger={['click']}>
							<a onClick={e => e.preventDefault()}>
								<Avatar
									style={{
										backgroundColor: '#1890ff',
										verticalAlign: 'middle'
									}}
									size='large'
								></Avatar>
							</a>
						</Dropdown>
					</div>
				</div>
			</Header>
			<Layout>
				<Sider
					collapsible
					collapsed={collapsed}
					onCollapse={handleSlider}
					theme='light'
					style={{
						overflow: 'auto',
						height: '100vh',
						position: isSiderFixed ? 'fixed' : 'relative',
						left: 0,
						top: 0
						// borderRight: '1px solid #d9d9d9'
					}}
				>
					<Menu
						style={{
							width: '100%',
							height: '100%'
						}}
						defaultSelectedKeys={['0']}
						mode='inline'
						items={MenuItems}
						onClick={handleMenuOption}
					/>
				</Sider>
				<Layout
					className='site-layout'
					style={{ marginLeft: isSiderFixed ? (collapsed ? 80 : 200) : 0 }}
				>
					<Content style={{ background: '#fff' }}>
						<div className='site-layout-background' style={{ paddingLeft: 24 }}>
							<Breadcrumb style={{ margin: '1rem 0' }} items={breadcrumb} />
						</div>

						<div
							className='site-layout-background'
							style={{ padding: '0 1.25rem', minHeight: 360 }}
						>
							{children}
						</div>
					</Content>
					{/* <Footer style={{ height: 0 }}>
						<CustomFooter />
					</Footer> */}
				</Layout>
			</Layout>
		</Layout>
	)
}

export default NewCustomLayout
