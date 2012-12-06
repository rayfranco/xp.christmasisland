throw "jQuery is not installed" if not $?
throw "Buzz is not installed" if not buzz?

$ ->

	# Configuration
	FLAKES_COUNT 	= 15000
	CAMERA_DISTANCE = 200

	# Variables
	nerve = .5 		# Environment tension

	#
	# Initialisation
	#

	# Set up the scene
	scene 	= new THREE.Scene()

	# Set up the camera
	camera 				= new THREE.PerspectiveCamera 75, window.innerWidth/window.innerHeight ,1, 120000
	camera.position.z 	= 200
	camera.position.y 	= 0

	# Set up the renderer
	rParameters =
		canvas: sceneCanvas
		clearColor: 0xFFFFFF
		clearAlpha: 0
		antialias: false
		autoClear: false
		gammaInput: true
		gammaOutput: true
		sort: false
	sceneCanvas = document.getElementById 'scene'
	renderer 	= new THREE.WebGLRenderer
	renderer.setSize window.innerWidth, window.innerHeight

	# Post Processing
	renderModel 	= new THREE.RenderPass scene, camera
	effectFilm 		= new THREE.FilmPass 3, 0.1, 0, true
	effectVignette 	= new THREE.ShaderPass THREE.VignetteShader
	effectColorify 	= new THREE.ShaderPass THREE.ColorifyShader

	effectVignette.uniforms["offset"].value 	= 0.8;
	effectVignette.uniforms["darkness"].value 	= 2;
	effectVignette.renderToScreen = true

	rtParameters = 
		minFilter: THREE.LinearFilter
		magFilter: THREE.LinearFilter
		format: THREE.RGBFormat
		stencilBuffer: true

	composer = new THREE.EffectComposer renderer, new THREE.WebGLRenderTarget window.innerWidth, window.innerHeight, rtParameters

	composer.addPass renderModel
	composer.addPass effectFilm
	composer.addPass effectVignette

	# Set up the head tracker
	trackerCanvas 	= document.getElementById 'trackerCanvas'
	trackerVideo 	= document.getElementById 'trackerVideo'
	htracker 		= new headtrackr.Tracker({ui: false, headPosition: true, calcAngles: false})

	htracker.init trackerVideo, trackerCanvas
	htracker.start() 	# We will listen to events later, get ready !

	# Load the skybox textures
	urlPrefix 	= "assets/textures/skybox/"
	urls 		= [ urlPrefix + "posx.jpg", urlPrefix + "negx.jpg",
    				urlPrefix + "posy.jpg", urlPrefix + "negy.jpg",
    				urlPrefix + "posz.jpg", urlPrefix + "negz.jpg" ]
	textureCube = THREE.ImageUtils.loadTextureCube(urls)

	# Load the main subject, a ball (yeah a ball, so what?)
	geometry 		= new THREE.SphereGeometry( 100, 32, 16 );
	material 		= new THREE.MeshBasicMaterial( { color: 0xffffff, envMap: textureCube } );
	mesh 			= new THREE.Mesh geometry, material
	mesh.position.x = 0 #Math.random() * 10000 - 5000
	mesh.position.y = 0 #Math.random() * 10000 - 5000
	mesh.position.z = 0 #Math.random() * 10000 - 5000
	mesh.scale.x 	= mesh.scale.y = mesh.scale.z = 1;

	scene.add mesh

	# Let's animate the ball
	ballDown 	= new TWEEN.Tween(mesh.position).to({y:-20},5000).easing(TWEEN.Easing.Cubic.InOut)
	ballUp 	 	= new TWEEN.Tween(mesh.position).to({y:20},5000).easing(TWEEN.Easing.Cubic.InOut)
	start 		= new TWEEN.Tween(mesh.position).to({y:20},2500).start().chain(ballDown).easing(TWEEN.Easing.Cubic.Out)
	ballDown.chain(ballUp) # Get up
	ballUp.chain(ballDown) # Get down
	
	# Make the skybox, it's getting nice now !
	shader 	 		= THREE.ShaderUtils.lib["cube"]
	smParameters 	=
		fragmentShader: shader.fragmentShader
		vertexShader: shader.vertexShader
		uniforms: shader.uniforms
		depthWrite: false
		side: THREE.BackSide

	shader.uniforms['tCube'].value = textureCube

	material = new THREE.ShaderMaterial smParameters
	mesh  	 = new THREE.Mesh( new THREE.CubeGeometry( 10000, 10000, 10000 ), material )

	scene.add mesh

	# Lights up
	pointLight 				= new THREE.PointLight 0x0000FF
	pointLight.position.x 	= 10
	pointLight.position.y 	= 50
	pointLight.position.z 	= 130

	scene.add pointLight

	directionalLight 		= new THREE.DirectionalLight 0xffffff, 1
	directionalLight.position.x = 1
	directionalLight.position.y = 1
	directionalLight.position.z = 0

	scene.add directionalLight

	light = new THREE.AmbientLight 0x666666
	
	scene.add light

	# This will be our particle manager, experimental !
	class FlakeStorm
		constructor: (@scene, @subject, @count) ->
			@flakes = new THREE.Geometry()
			@material = new THREE.ParticleBasicMaterial({
				size: 5,
				map: THREE.ImageUtils.loadTexture("assets/particle.png"),
				blending: THREE.AdditiveBlending,
				transparent: true
			})
			@points = new THREE.GeometryUtils.randomPointsInGeometry @subject, @count
			for i in [0...@count]
				@points[i] = new THREE.Vector3 Math.random() * 400 - 200, Math.random() * 400 - 200, Math.random() * 2000 - 1000
				particle = new Flake @points[i], 50
				#particle.explode()
				@flakes.vertices.push(particle)
			@system = new THREE.ParticleSystem @flakes, @material
			console.log @flakes
			@system.sortParticles = true;
			console.log @flakes
			@scene.add @system
			console.log @flakes
			return @
		update: ->
			for flake in @flakes.vertices
				if flake.y < -200
					flake.y = 200
				if flake.x < -200
					flake.x = 200
				if flake.x > 200
					flake.x = -200
				else
					flake.y -= 0.5 * Math.random()
					flake.x -= 0.5 * Math.random()

	# This is our flake (particle) - experimental !
	class Flake extends THREE.Vector3
		constructor: (vector, r=2) ->
			@velocity = new THREE.Vector3 0, -Math.random() + 1, 0
			@animation = null
			@x = vector.x
			@y = vector.y
			@z = vector.z
			return @

	storm = new FlakeStorm scene, geometry, FLAKES_COUNT

	# Add sounds to the game
	soundOptions =
		preload: true
		autoplay: false
		loop: true

	track1 = new buzz.sound 'assets/loop1.wav', soundOptions
	track2 = new buzz.sound 'assets/loop2.wav', soundOptions
	track3 = new buzz.sound 'assets/loop3.wav', soundOptions
	buzz.all().bindOnce 'canplaythrough', ->
		console.log 'canplaythrough'
		buzz.all().play()

	# Set initial volumes
	track1.setVolume 100
	track2.setVolume 20
	track3.setVolume 0

	buzz.all()

	# Variable globale ?
	percentX = .5
	percentY = .5

	# Render all that stuff
	render = ->
		TWEEN.update()
		requestAnimationFrame render
		renderer.render scene, camera
		#camera.lookAt({x:0,y:0,z:0})
		storm.update()
		camX = percentX * 400 - 200
		camZ = Math.sqrt( Math.pow(200,2) - Math.pow(camX,2) )
		new TWEEN.Tween(camera.position).to({x: camX}, 980).easing(TWEEN.Easing.Cubic.Out).start();
		composer.render(0.0001)
	render()

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
			console.log trackrStatuses[e.status]

	document.addEventListener 'facetrackingEvent', (e) ->
		percentX = nerve = 1 - e.x / 318
		percentY = 1 - e.y / 240

		#sound update
		track1.setVolume percentX * 100
		track2.setVolume 100 - percentX * 100
		track3.setVolume 100 - percentX * 150

	# Will make the animation nice
	lightenScreen = () ->
		anim = new TWEEN.Tween({grayscale: 0, nIntensity: 0.1}).to({grayscale: 1, nIntensity: 3},500).easing(TWEEN.Easing.Cubic.Out)
		anim.onUpdate ->
			effectFilm.uniforms["grayscale"].value = this.grayscale
			effectFilm.uniforms["nIntensity"].value = this.nIntensity
		anim.start()

	# Will put the animation in background mode
	darkenScreen = () ->
		anim = new TWEEN.Tween({grayscale: 1, nIntensity: 3}).to({grayscale: 0, nIntensity: 0.1},500).easing(TWEEN.Easing.Cubic.Out)
		anim.onUpdate ->
			effectFilm.uniforms["grayscale"].value = this.grayscale
			effectFilm.uniforms["nIntensity"].value = this.nIntensity
		anim.start()