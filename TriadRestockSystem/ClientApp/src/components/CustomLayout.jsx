import { UserOutlined } from '@ant-design/icons'
import { Avatar, Breadcrumb, Layout, Menu, Popover } from 'antd'
import Animate from 'rc-animate'
import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { capitalizeFirstLetters } from '../functions/refractors'
import '../styles/DefaultContentStyle.css'
import Loader from './Loader'
import { MenuItems, UserMenuItems } from './MenuItems'

const { Header, Content, Sider } = Layout

const CustomLayout = ({ children }) => {
	const { fullname, username, roles, destroyStoredAuth } =
		useContext(AuthContext)
	const { active, collapsed, breadcrumb, handleSlider } =
		useContext(LayoutContext)
	const navigate = useNavigate()
	const [isSiderFixed, setIsSiderFixed] = useState(false)

	const handleUserMenuOption = e => {
		switch (e.key) {
			case 'logout':
				destroyStoredAuth()
				window.location.reload()
				break
			default:
				break
		}
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
			case 11:
				path = '/banks'
				break
			case 13:
				path = '/concepts'
				break
			case 14:
				path = '/orders'
				break
			case 15:
				path = '/requisitions'
				break
			default:
				break
		}

		navigate(path)
	}

	useEffect(() => {
		console.log(
			roles,
			MenuItems.filter(m => m.roles?.some(r => roles.includes(r)))
		)

		const handleScroll = () => {
			const scrollTop = window.scrollY || document.documentElement.scrollTop
			setIsSiderFixed(scrollTop >= 65)
		}

		window.addEventListener('scroll', handleScroll)

		return () => {
			window.removeEventListener('scroll', handleScroll)
		}
	}, [username, roles])

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
						<Popover
							content={
								<>
									<div
										style={{
											display: 'flex',
											flexDirection: 'column',
											justifyContent: 'center',
											marginLeft: '1rem',
											marginRight: '1rem'
										}}
									>
										<div style={{ display: 'flex', justifyContent: 'center' }}>
											<Avatar size={64} icon={<UserOutlined />} />
										</div>
										<span
											style={{
												fontSize: '1rem',
												fontWeight: 600,
												width: '100%',
												textAlign: 'center'
											}}
										>
											{fullname}
										</span>
										{roles.map(r => {
											let text = ''

											switch (r) {
												case 'ADMINISTRADOR':
													text = 'Administrador'
													break
												case 'ALMACEN_ENCARGADO':
													text = 'Encargado de almacén'
													break
												case 'ALMACEN_AUXILIAR':
													text = 'Auxiliar de almacén'
													break
												case 'PRESUPUESTO':
													text = 'Presupuesto'
													break
												case 'COMPRAS':
													text = 'Compras'
													break
												case 'CENTROCOSTOS_ENCARGADO':
													text = 'Encargado de Centro de costo'
													break
												case 'CENTROCOSTOS_AUXILIAR':
													text = 'Auxiliar de Centro de costo'
													break
												default:
													break
											}

											return (
												<span
													key={r}
													style={{
														fontSize: '0.65rem',
														width: '100%',
														textAlign: 'center'
													}}
												>
													{text}
												</span>
											)
										})}
									</div>
									<div style={{ marginTop: '0.5rem' }}>
										<Menu
											style={{ border: 'none' }}
											mode='inline'
											items={UserMenuItems}
											onClick={handleUserMenuOption}
										/>
									</div>
								</>
							}
							trigger='click'
						>
							<Avatar size='large'>{capitalizeFirstLetters(fullname)}</Avatar>
						</Popover>
						{/* <Dropdown menu={{ items, onClick }} trigger={['click']}>
							<a onClick={e => e.preventDefault()}>
								<Avatar
									style={{
										backgroundColor: '#1890ff',
										verticalAlign: 'middle'
									}}
									size='large'
								></Avatar>
							</a>
						</Dropdown> */}
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
						items={MenuItems.filter(m => m.roles?.some(r => roles.includes(r)))}
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

export default CustomLayout
