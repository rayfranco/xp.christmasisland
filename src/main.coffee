# Set up the scene
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera 75, window.innerWidth/window.innerHeight ,0.1, 1000

# Set up the renderer
renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement);

# Set up some objects
geometry = new THREE.CubeGeometry 1, 1, 1
material = new THREE.MeshLambertMaterial {color: 0xff0000}
cube = new THREE.Mesh geometry, material
scene.add cube

# Lights up
pointLight = new THREE.PointLight 0xFFFFFF
pointLight.position.x = 10
pointLight.position.y = 50
pointLight.position.z = 130
scene.add pointLight

# Init camera position
camera.position.z = 50

# Render all that stuff
render = ->
	requestAnimationFrame render
	renderer.render scene, camera
	#cube.rotation.x += 0.1
	#cube.rotation.y += 0.1
render()

# Set up the tracker
videoInput = document.getElementById 'inputVideo'
canvasInput = document.getElementById 'inputCanvas'
htracker = new headtrackr.Tracker({ui: false, headPosition: true, calcAngles: false})
htracker.init videoInput, canvasInput
htracker.start()

# Add some particles

particleCount = 1800
particles = new THREE.Geometry()
pMaterial = new THREE.ParticleBasicMaterial { color: 0xFFFFFF, size: 2 }

for p in [0...1800]
	pX = Math.random() * 500 - 250
	pY = Math.random() * 500 - 250
	pZ = Math.random() * 500 - 250
	particle = new THREE.Vertex new THREE.Vector3(pX, pY, pZ)
	particles.vertices.push(particle);

particleSystem = new THREE.ParticleSystem particles, pMaterial

scene.add particleSystem

# Debug bar

class Debug
	constructor: (el) ->
		@el = document.getElementById(el)
	message: (msg) ->
		@el.innerHtml = msg

debug = new Debug('debugBar');

# Give me some messages
trackrStatuses =
	"getUserMedia": "You got that camera"
	"no getUserMedia": "u shy ? Turn that camera on..."
	"camera found": "Camera is working"
	"no camera": "Hey, u dat shy ?"
	"detecting": "Don't hide, tryin to find u..."
	"found": "Gotcha ! You can move now :)"
	"lost": "Hey !! Where are ya ??"
	"redetecting": "Tryin to find you again"

document.addEventListener 'headtrackrStatus', (e) ->
	if e.status of trackrStatuses
		debug.message trackrStatuses[e.status]

document.addEventListener 'facetrackingEvent', (e) ->
	camera.position.x = (e.x - 200) * -1
	camera.position.y = (e.y - 100) * -1
