// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if (!(typeof $ !== "undefined" && $ !== null)) {
    throw "jQuery is not installed";
  }

  $(function() {
    var Flake, FlakeStorm, PARTICLES_COUNT, animated, camera, cube, geometry, htracker, material, nerve, pointLight, render, renderer, scene, sceneCanvas, soundOptions, storm, track1, track2, track3, trackerCanvas, trackerVideo, trackrStatuses;
    nerve = .5;
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    sceneCanvas = document.getElementById('scene');
    renderer = new THREE.WebGLRenderer({
      canvas: sceneCanvas
    });
    renderer.setSize(window.innerWidth, window.innerHeight);
    geometry = new THREE.SphereGeometry(50, 16, 16);
    material = new THREE.MeshLambertMaterial({
      color: 0xff0000
    });
    cube = new THREE.Mesh(geometry, material);
    cube.position = new THREE.Vector3(0, 0, 0);
    scene.add(cube);
    trackerCanvas = document.getElementById('trackerCanvas');
    trackerVideo = document.getElementById('trackerVideo');
    htracker = new headtrackr.Tracker({
      ui: false,
      headPosition: true,
      calcAngles: false
    });
    htracker.init(trackerVideo, trackerCanvas);
    htracker.start();
    pointLight = new THREE.PointLight(0x0000FF);
    pointLight.position.x = 10;
    pointLight.position.y = 50;
    pointLight.position.z = 130;
    scene.add(pointLight);
    camera.position.z = 500;
    camera.position.y = 50;
    camera.lookAt(cube.position);
    FlakeStorm = (function() {

      function FlakeStorm(scene, subject, count) {
        var i, particle, _i, _ref;
        this.scene = scene;
        this.subject = subject;
        this.count = count;
        this.flakes = new THREE.Geometry();
        this.material = new THREE.ParticleBasicMaterial({
          size: 2,
          map: THREE.ImageUtils.loadTexture("assets/particle.png"),
          blending: THREE.AdditiveBlending,
          depthTest: false,
          transparent: true
        });
        this.points = new THREE.GeometryUtils.randomPointsInGeometry(this.subject, this.count);
        for (i = _i = 0, _ref = this.count; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          particle = new Flake(this.points[i], 10);
          particle.explode();
          this.flakes.vertices.push(particle);
        }
        this.system = new THREE.ParticleSystem(this.flakes, this.material);
        console.log(this.flakes);
        this.system.sortParticles = true;
        console.log(this.flakes);
        this.scene.add(this.system);
        console.log(this.flakes);
        return this;
      }

      FlakeStorm.prototype.flake = function() {
        var flake, _i, _len, _ref, _results;
        _ref = this.flakes.vertices;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          flake = _ref[_i];
          _results.push(flake.flake());
        }
        return _results;
      };

      FlakeStorm.prototype.explode = function() {
        var flake, _i, _len, _ref;
        _ref = this.flakes.vertices;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          flake = _ref[_i];
          flake.explode(2500).animate();
        }
        this.onAnimationEnd();
        return this;
      };

      FlakeStorm.prototype.implode = function() {
        var flake, _i, _len, _ref;
        _ref = this.flakes.vertices;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          flake = _ref[_i];
          flake.implode(2500).animate();
        }
        this.onAnimationEnd();
        return this;
      };

      FlakeStorm.prototype.onAnimationEnd = function() {};

      return FlakeStorm;

    })();
    Flake = (function(_super) {

      __extends(Flake, _super);

      function Flake(vector, r) {
        var _this = this;
        if (r == null) {
          r = 2;
        }
        this.velocity = new THREE.Vector3(0, -Math.random() + 1, 0);
        this.animation = null;
        this.x = vector.x;
        this.y = vector.y;
        this.z = vector.z;
        this.implodeSet = {
          x: this.x,
          y: this.y,
          z: this.z
        };
        this.explodeSet = {
          x: this.x * r,
          y: this.y * r,
          z: this.z * r
        };
        this.explodeTween = new TWEEN.Tween(this).to(this.explodeSet, 2500).easing(TWEEN.Easing.Elastic.Out);
        this.flakeTween = new TWEEN.Tween(this).to({
          y: -200
        }, 800);
        this.implodeTween = new TWEEN.Tween(this).to(this.implodeSet, 2500).easing(TWEEN.Easing.Elastic.Out);
        this.explodeTween.onComplete(function() {
          return _this.flake;
        });
        this.flakeTween.onComplete(function() {
          _this.y = 200;
          if (_this.animation) {
            return _this.animation.chain(_this.flakeTween);
          } else {
            return _this.animation = _this.flakeTween.start();
          }
        });
        return this;
      }

      Flake.prototype.explode = function(t) {
        if (this.animation) {
          this.animation.chain(this.explodeTween);
        } else {
          this.animation = this.explodeTween.start();
        }
        return this;
      };

      Flake.prototype.implode = function(t) {
        this.animation = this.implodeTween.start();
        return this;
      };

      Flake.prototype.flake = function() {
        this.animation.chain(this.flakeTween);
        return this;
      };

      Flake.prototype.animate = function() {
        if (this.animation) {
          this.animation.start();
        }
        return this;
      };

      return Flake;

    })(THREE.Vector3);
    PARTICLES_COUNT = 1500;
    storm = new FlakeStorm(scene, geometry, PARTICLES_COUNT);
    animated = 1;
    $(document).click(function() {
      if (animated === 1) {
        storm.explode();
        return animated = 0;
      } else {
        storm.implode();
        return animated = 1;
      }
    });
    if (!(typeof buzz !== "undefined" && buzz !== null)) {
      throw "Buzz is not installed";
    }
    soundOptions = {
      preload: true,
      autoplay: false,
      loop: true
    };
    track1 = new buzz.sound('assets/loop1.wav', soundOptions);
    track2 = new buzz.sound('assets/loop2.wav', soundOptions);
    track3 = new buzz.sound('assets/loop3.wav', soundOptions);
    buzz.all().bindOnce('canplaythrough', function() {
      console.log('canplaythrough');
      return buzz.all().play();
    });
    track1.setVolume(100);
    track2.setVolume(20);
    track3.setVolume(0);
    buzz.all();
    render = function() {
      TWEEN.update();
      storm.system.rotation.y += 0.01;
      requestAnimationFrame(render);
      return renderer.render(scene, camera);
    };
    render();
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
        return console.log(trackrStatuses[e.status]);
      }
    });
    document.addEventListener('facetrackingEvent', function(e) {
      var percentX, percentY;
      percentX = nerve = e.x / 320;
      percentY = e.y / 240;
      new TWEEN.Tween(camera.position).to({
        x: -percentX * 200,
        y: percentY * 200
      }, 980).easing(TWEEN.Easing.Cubic.Out).onUpdate(function() {}).start();
      track1.setVolume(percentX * 100);
      track2.setVolume(100 - percentX * 100);
      return track3.setVolume(100 - percentX * 150);
    });
    return window.camera = camera;
  });

}).call(this);
