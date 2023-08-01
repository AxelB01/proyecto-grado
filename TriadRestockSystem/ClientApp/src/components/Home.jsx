import { useContext, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import AuthContext from '../context/AuthContext'
import LayoutContext from '../context/LayoutContext'
import { sleep } from '../functions/sleep'
import Loader from './Loader'

const Home = () => {
	const { validLogin } = useContext(AuthContext)
	const { handleLayout } = useContext(LayoutContext)
	const navigate = useNavigate()
	const [loaded, setLoaded] = useState(true)

	useEffect(() => {
		document.title = 'Home'
		async function waitForUpdate() {
			await sleep(1000)
		}

		if (!validLogin) {
			waitForUpdate()
			handleLayout(false)
			navigate('/login')
		} else {
			handleLayout(true)
			setLoaded(false)
		}
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [])

	return loaded ? (
		<Loader />
	) : (
		<>
			<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
				tempor incididunt ut labore et dolore magna aliqua. Et malesuada fames
				ac turpis. Id cursus metus aliquam eleifend. Nunc sed augue lacus
				viverra vitae congue eu consequat ac. Tincidunt arcu non sodales neque
				sodales ut. Pretium aenean pharetra magna ac placerat vestibulum lectus.
				Ipsum nunc aliquet bibendum enim facilisis gravida neque convallis a.
				Massa ultricies mi quis hendrerit. Orci eu lobortis elementum nibh.
				Habitasse platea dictumst quisque sagittis purus sit amet. Pretium
				lectus quam id leo in vitae. Ullamcorper dignissim cras tincidunt
				lobortis feugiat vivamus at augue. Malesuada pellentesque elit eget
				gravida cum. Sed lectus vestibulum mattis ullamcorper velit sed
				ullamcorper morbi tincidunt. Felis donec et odio pellentesque diam.
				Lectus sit amet est placerat in egestas erat imperdiet sed. Dictum
				varius duis at consectetur lorem donec massa sapien faucibus. Libero id
				faucibus nisl tincidunt. Malesuada nunc vel risus commodo viverra
				maecenas. Sit amet porttitor eget dolor morbi. Sed elementum tempus
				egestas sed sed risus pretium quam vulputate. Cursus metus aliquam
				eleifend mi in. Enim diam vulputate ut pharetra. Tempor nec feugiat nisl
				pretium fusce. Rhoncus mattis rhoncus urna neque viverra justo. Tellus
				pellentesque eu tincidunt tortor aliquam nulla. Dictum varius duis at
				consectetur lorem donec. Sit amet risus nullam eget felis eget nunc
				lobortis. Luctus accumsan tortor posuere ac ut consequat semper. Mi sit
				amet mauris commodo quis. Tellus mauris a diam maecenas sed. Dictum at
				tempor commodo ullamcorper a lacus vestibulum sed arcu. Feugiat
				scelerisque varius morbi enim nunc faucibus a pellentesque sit.
				Pellentesque dignissim enim sit amet. Nisl nunc mi ipsum faucibus vitae
				aliquet nec ullamcorper sit. Nulla facilisi nullam vehicula ipsum a arcu
				cursus vitae. In mollis nunc sed id semper. Vestibulum rhoncus est
				pellentesque elit ullamcorper dignissim cras tincidunt. Sit amet commodo
				nulla facilisi nullam vehicula ipsum a. Arcu odio ut sem nulla pharetra
				diam sit amet. Donec ac odio tempor orci dapibus ultrices. Nunc sed
				blandit libero volutpat sed cras ornare. Fringilla urna porttitor
				rhoncus dolor purus. Id cursus metus aliquam eleifend mi. Congue mauris
				rhoncus aenean vel elit. Facilisis leo vel fringilla est. Consequat ac
				felis donec et odio pellentesque diam volutpat commodo. Rutrum tellus
				pellentesque eu tincidunt tortor aliquam nulla facilisi cras. At auctor
				urna nunc id cursus metus aliquam eleifend mi. Risus pretium quam
				vulputate dignissim. Id neque aliquam vestibulum morbi blandit cursus.
				Neque laoreet suspendisse interdum consectetur libero id faucibus. Non
				pulvinar neque laoreet suspendisse interdum consectetur. Dignissim diam
				quis enim lobortis scelerisque fermentum dui faucibus in. Tempus quam
				pellentesque nec nam aliquam sem et tortor. Nec dui nunc mattis enim ut
				tellus. Euismod in pellentesque massa placerat. Nibh nisl condimentum id
				venenatis a condimentum. Bibendum at varius vel pharetra vel. Etiam
				dignissim diam quis enim lobortis scelerisque. Metus dictum at tempor
				commodo ullamcorper a lacus vestibulum sed. Vestibulum morbi blandit
				cursus risus at ultrices mi. Amet mattis vulputate enim nulla aliquet
				porttitor lacus luctus. Et netus et malesuada fames ac turpis egestas
				sed tempus. Viverra mauris in aliquam sem fringilla ut morbi tincidunt.
				Urna duis convallis convallis tellus id interdum velit laoreet. Ornare
				arcu odio ut sem nulla pharetra diam. Faucibus turpis in eu mi bibendum
				neque egestas. Elementum tempus egestas sed sed risus pretium quam
				vulputate. Euismod elementum nisi quis eleifend quam. Turpis egestas
				pretium aenean pharetra magna ac placerat vestibulum lectus. Est ante in
				nibh mauris cursus. Ullamcorper a lacus vestibulum sed. Lorem mollis
				aliquam ut porttitor leo a diam. Turpis egestas sed tempus urna et
				pharetra pharetra. Consectetur libero id faucibus nisl tincidunt eget
				nullam non. Massa tincidunt nunc pulvinar sapien et ligula ullamcorper
				malesuada. Pharetra diam sit amet nisl suscipit. Fermentum leo vel orci
				porta non pulvinar. Eu facilisis sed odio morbi quis commodo. Pulvinar
				neque laoreet suspendisse interdum consectetur libero id faucibus nisl.
				Mauris augue neque gravida in fermentum et sollicitudin ac. A
				condimentum vitae sapien pellentesque habitant morbi tristique senectus.
				Tellus integer feugiat scelerisque varius morbi enim nunc faucibus a.
				Eget arcu dictum varius duis at consectetur lorem. Commodo elit at
				imperdiet dui accumsan sit amet nulla facilisi. Diam quam nulla
				porttitor massa id neque aliquam. Risus pretium quam vulputate
				dignissim. Lacinia at quis risus sed vulputate odio ut. Vivamus at augue
				eget arcu dictum varius duis. Ornare arcu odio ut sem nulla pharetra
				diam sit. Consequat ac felis donec et. Imperdiet dui accumsan sit amet
				nulla facilisi morbi tempus. Sit amet mauris commodo quis imperdiet
				massa tincidunt nunc pulvinar. Ac tortor dignissim convallis aenean et
				tortor at risus viverra. Lectus sit amet est placerat in egestas erat
				imperdiet sed. Et ultrices neque ornare aenean euismod elementum nisi.
				Eu lobortis elementum nibh tellus molestie nunc non. Ornare quam viverra
				orci sagittis eu volutpat. Elit duis tristique sollicitudin nibh sit.
				Maecenas ultricies mi eget mauris. Arcu odio ut sem nulla pharetra diam
				sit amet. Amet consectetur adipiscing elit duis tristique sollicitudin
				nibh. Nec sagittis aliquam malesuada bibendum arcu vitae elementum. Et
				odio pellentesque diam volutpat commodo sed egestas egestas. Maecenas
				pharetra convallis posuere morbi leo urna molestie at elementum. Et
				malesuada fames ac turpis egestas sed tempus. Aliquam ultrices sagittis
				orci a scelerisque purus semper. Tempor commodo ullamcorper a lacus.
				Tincidunt id aliquet risus feugiat in ante. Volutpat odio facilisis
				mauris sit amet massa vitae tortor condimentum. Lacinia at quis risus
				sed vulputate odio ut. Accumsan in nisl nisi scelerisque eu. Sit amet
				mauris commodo quis imperdiet massa tincidunt. In iaculis nunc sed augue
				lacus viverra vitae congue eu. Id neque aliquam vestibulum morbi.
				Blandit volutpat maecenas volutpat blandit aliquam etiam erat velit.
				Arcu felis bibendum ut tristique et egestas quis. Pretium vulputate
				sapien nec sagittis aliquam malesuada bibendum. Nec feugiat nisl pretium
				fusce. Fames ac turpis egestas integer eget aliquet. Purus viverra
				accumsan in nisl nisi scelerisque eu ultrices vitae. Sit amet cursus sit
				amet. Suscipit adipiscing bibendum est ultricies integer quis auctor
				elit. Faucibus et molestie ac feugiat. Arcu non sodales neque sodales.
				Luctus accumsan tortor posuere ac ut consequat semper viverra. Velit
				laoreet id donec ultrices tincidunt arcu. Interdum velit euismod in
				pellentesque massa placerat duis. Montes nascetur ridiculus mus mauris
				vitae ultricies leo integer. A iaculis at erat pellentesque. Tellus
				molestie nunc non blandit massa enim nec dui. Nisi porta lorem mollis
				aliquam ut porttitor leo a. Faucibus interdum posuere lorem ipsum dolor
				sit amet consectetur. Mauris ultrices eros in cursus turpis massa
				tincidunt. Iaculis eu non diam phasellus vestibulum lorem sed risus
				ultricies. Pellentesque massa placerat duis ultricies lacus sed turpis.
				Risus viverra adipiscing at in tellus integer feugiat scelerisque. Eget
				gravida cum sociis natoque penatibus et magnis. Nibh ipsum consequat
				nisl vel pretium. Auctor elit sed vulputate mi. Porta lorem mollis
				aliquam ut porttitor leo a. Facilisis gravida neque convallis a cras.
				Nibh sit amet commodo nulla facilisi nullam vehicula. Diam in arcu
				cursus euismod. Nunc sed id semper risus in hendrerit gravida. Amet
				volutpat consequat mauris nunc congue nisi. In hac habitasse platea
				dictumst quisque sagittis. Fermentum leo vel orci porta non pulvinar
				neque laoreet suspendisse. Gravida rutrum quisque non tellus. Tortor at
				auctor urna nunc id cursus metus aliquam. Bibendum est ultricies integer
				quis auctor elit sed vulputate mi. Aliquam malesuada bibendum arcu vitae
				elementum curabitur vitae. Vulputate odio ut enim blandit volutpat
				maecenas volutpat. Amet dictum sit amet justo donec. Egestas diam in
				arcu cursus euismod quis viverra. Elementum integer enim neque volutpat.
				Dignissim enim sit amet venenatis urna cursus eget nunc scelerisque. Sit
				amet tellus cras adipiscing enim eu turpis egestas. Cursus metus aliquam
				eleifend mi in nulla posuere. Vulputate enim nulla aliquet porttitor
				lacus luctus. Praesent elementum facilisis leo vel fringilla est. Eget
				aliquet nibh praesent tristique magna sit amet. Nulla facilisi etiam
				dignissim diam quis enim. Amet justo donec enim diam vulputate ut
				pharetra sit. Nunc consequat interdum varius sit amet mattis vulputate
				enim nulla. Vel fringilla est ullamcorper eget nulla facilisi etiam
				dignissim. Dui id ornare arcu odio ut sem nulla.
			</p>
		</>
	)
}

export default Home
