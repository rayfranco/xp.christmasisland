throw "jQuery is not installed" if not $?

$ ->
	# You CAN be nervous ;)
	nerve = .5

	# Set up the scene
	scene = new THREE.Scene()
	camera = new THREE.PerspectiveCamera 75, window.innerWidth/window.innerHeight ,0.1, 1000

	# Set up the renderer
	sceneCanvas = document.getElementById 'scene'
	renderer = new THREE.WebGLRenderer({ canvas: sceneCanvas })
	renderer.setSize(window.innerWidth, window.innerHeight)
	# Set up some objects
	# geometry = new THREE.CubeGeometry 1, 1, 1
	# material = new THREE.MeshLambertMaterial {color: 0xff0000}
	# cube = new THREE.Mesh geometry, material
	# scene.add cube

	
	# Set up the tracker
	trackerCanvas 	= document.getElementById 'trackerCanvas'
	trackerVideo 	= document.getElementById 'trackerVideo'
	htracker = new headtrackr.Tracker({ui: false, headPosition: true, calcAngles: false})
	htracker.init trackerVideo, trackerCanvas
	htracker.start()

	# Lights up
	pointLight = new THREE.PointLight 0x0000FF
	pointLight.position.x = 10
	pointLight.position.y = 50
	pointLight.position.z = 130

	scene.add pointLight

	# Init camera position
	camera.position.z = 50
	camera.position.y = 50

	# Add some particles

	particleCount = 5000
	particles = new THREE.Geometry()
	material = new THREE.ParticleBasicMaterial({
	    size: 10,
	    map: THREE.ImageUtils.loadTexture("assets/particle.png"),
	    blending: THREE.AdditiveBlending,
	    depthTest: false,
	    transparent: true
	  });

	for p in [0...particleCount]
		pX = Math.random() * 500 - 250
		pY = Math.random() * 500 - 250
		pZ = Math.random() * 500 - 250
		particle = new THREE.Vector3 pX, pY, pZ
		particle.velocity = new THREE.Vector3 0, -Math.random(), 0
		particles.vertices.push(particle);

	particleSystem = new THREE.ParticleSystem particles, material

	particleSystem.sortParticles = true;

	scene.add particleSystem

	# Add sounds to the game
	throw "Buzz is not installed" if not buzz?
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

	console.log buzz.all()



	# Render all that stuff
	render = ->
		TWEEN.update()
		requestAnimationFrame render
		renderer.render scene, camera

		time = Date.now() * 0.00005
		h = ( 360 * ( 1.0 + time ) % 360 ) / 360;
		material.color.setHSV h, 1.0, 1.0

		for i in [0...particleCount]
			particle = particles.vertices[i]
			particle.y = 200 if particle.y < -200
			#particle.y -= Math.random() * .1
			# if particle.isAnimated
			# 	particle.isAnimated = true
			new TWEEN.Tween(particle).to({x: particle.x + Math.random() * (nerve - 50) * 1000, y: particle.y + Math.random() * (nerve - 50) * 100},.2)
			
			particle.addSelf particle.velocity
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
		percentX = nerve = e.x / 320
		percentY = e.y / 240

		new TWEEN.Tween(camera.position).to({x: -percentX * 200, y: percentY * 200}, 980).easing(TWEEN.Easing.Cubic.Out).onUpdate(()->
			#console.log @x
		).start();

		#sound update
		track1.setVolume percentX * 100
		track2.setVolume 100 - percentX * 100
		track3.setVolume 100 - percentX * 150


	#for test purpose
	window.camera = camera

