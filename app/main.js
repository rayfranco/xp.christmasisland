(function() {
  var Debug, camera, canvasInput, cube, debug, geometry, htracker, material, p, pMaterial, pX, pY, pZ, particle, particleCount, particleSystem, particles, pointLight, render, renderer, scene, trackrStatuses, videoInput, _i;

  scene = new THREE.Scene();

  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

  renderer = new THREE.WebGLRenderer();

  renderer.setSize(window.innerWidth, window.innerHeight);

  document.body.appendChild(renderer.domElement);

  geometry = new THREE.CubeGeometry(1, 1, 1);

  material = new THREE.MeshLambertMaterial({
    color: 0xff0000
  });

  cube = new THREE.Mesh(geometry, material);

  scene.add(cube);

  pointLight = new THREE.PointLight(0xFFFFFF);

  pointLight.position.x = 10;

  pointLight.position.y = 50;

  pointLight.position.z = 130;

  scene.add(pointLight);

  camera.position.z = 50;

  render = function() {
    requestAnimationFrame(render);
    return renderer.render(scene, camera);
  };

  render();

  videoInput = document.getElementById('inputVideo');

  canvasInput = document.getElementById('inputCanvas');

  htracker = new headtrackr.Tracker({
    ui: false,
    headPosition: true,
    calcAngles: false
  });

  htracker.init(videoInput, canvasInput);

  htracker.start();

  particleCount = 1800;

  particles = new THREE.Geometry();

  pMaterial = new THREE.ParticleBasicMaterial({
    color: 0xFFFFFF,
    size: 2
  });

  for (p = _i = 0; _i < 1800; p = ++_i) {
    pX = Math.random() * 500 - 250;
    pY = Math.random() * 500 - 250;
    pZ = Math.random() * 500 - 250;
    particle = new THREE.Vertex(new THREE.Vector3(pX, pY, pZ));
    particles.vertices.push(particle);
  }

  particleSystem = new THREE.ParticleSystem(particles, pMaterial);

  scene.add(particleSystem);

  Debug = (function() {

    function Debug(el) {
      this.el = document.getElementById(el);
    }

    Debug.prototype.message = function(msg) {
      return this.el.innerHtml = msg;
    };

    return Debug;

  })();

  debug = new Debug('debugBar');

  trackrStatuses = {
    "getUserMedia": "You got that camera",
    "no getUserMedia": "u shy ? Turn that camera on...",
    "camera found": "Camera is working",
    "no camera": "Hey, u dat shy ?",
    "detecting": "Don't hide, tryin to find u...",
    "found": "Gotcha ! You can move now :)",
    "lost": "Hey !! Where are ya ??",
    "redetecting": "Tryin to find you again"
  };

  document.addEventListener('headtrackrStatus', function(e) {
    if (e.status in trackrStatuses) {
      return debug.message(trackrStatuses[e.status]);
    }
  });

  document.addEventListener('facetrackingEvent', function(e) {
    camera.position.x = (e.x - 200) * -1;
    return camera.position.y = (e.y - 100) * -1;
  });

}).call(this);
