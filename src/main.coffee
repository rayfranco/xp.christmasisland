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

	# Set up central 
	geometry = new THREE.SphereGeometry 50, 16, 16
	material = new THREE.MeshLambertMaterial {color: 0xff0000}
	cube = new THREE.Mesh geometry, material
	cube.position = new THREE.Vector3 0, 0, 0
	scene.add cube

	
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
	camera.position.z = 500
	camera.position.y = 50
	camera.lookAt(cube.position)

	# Add some particles

	class FlakeStorm
		constructor: (@scene, @subject, @count) ->
			@flakes = new THREE.Geometry()
			@material = new THREE.ParticleBasicMaterial({
				size: 2,
				map: THREE.ImageUtils.loadTexture("assets/particle.png"),
				blending: THREE.AdditiveBlending,
				depthTest: false,
				transparent: true
			})
			@points = new THREE.GeometryUtils.randomPointsInGeometry @subject, @count
			for i in [0...@count]
				particle = new Flake @points[i], 10
				particle.explode()
				@flakes.vertices.push(particle)
			@system = new THREE.ParticleSystem @flakes, @material
			console.log @flakes
			@system.sortParticles = true;
			console.log @flakes
			@scene.add @system
			console.log @flakes
			return @
		flake: ->
			flake.flake() for flake in @flakes.vertices
		explode: ->
			flake.explode(2500).animate() for flake in @flakes.vertices
			@onAnimationEnd()
			return @
		implode: ->
			flake.implode(2500).animate() for flake in @flakes.vertices
			@onAnimationEnd()
			return @
		onAnimationEnd: ->

	class Flake extends THREE.Vector3
		constructor: (vector, r=2) ->
			@velocity = new THREE.Vector3 0, -Math.random() + 1, 0
			@animation = null
			@x = vector.x
			@y = vector.y
			@z = vector.z


			@implodeSet =
				x: @x
				y: @y
				z: @z
			@explodeSet =
				x: @x * r
				y: @y * r
				z: @z * r

			@explodeTween = new TWEEN.Tween(@).to(@explodeSet,2500).easing(TWEEN.Easing.Elastic.Out)
			@flakeTween = new TWEEN.Tween(@).to({y: -200},800)
			@implodeTween = new TWEEN.Tween(@).to(@implodeSet,2500).easing(TWEEN.Easing.Elastic.Out)

			@explodeTween.onComplete => 
				@flake
			@flakeTween.onComplete =>
				@y = 200
				if @animation then @animation.chain(@flakeTween) else @animation = @flakeTween.start()

			return @
		explode: (t) ->
			if @animation then @animation.chain(@explodeTween) else @animation = @explodeTween.start()
			return @
		implode: (t) ->
			@animation = @implodeTween.start()
			return @
		flake: ->
			@animation.chain(@flakeTween)
			return @
		animate: ->
			@animation.start() if @animation
			return @

	PARTICLES_COUNT = 1500

	storm = new FlakeStorm scene, geometry, PARTICLES_COUNT

	animated = 1
	$(document).click -> 
		if animated is 1
			storm.explode()
			animated = 0
		else
			storm.implode()
			animated = 1

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

	buzz.all()

	# Render all that stuff
	render = ->
		TWEEN.update()
		storm.system.rotation.y += 0.01
		requestAnimationFrame render
		renderer.render scene, camera
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

