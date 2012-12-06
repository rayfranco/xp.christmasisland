(function(){var t;t=function(){function t(){}return t}()}).call(this),function(){var t;t=function(){function t(){}return t}()}.call(this),function(){var t={}.hasOwnProperty,e=function(e,n){function i(){this.constructor=e}for(var o in n)t.call(n,o)&&(e[o]=n[o]);return i.prototype=n.prototype,e.prototype=new i,e.__super__=n.prototype,e};if("undefined"==typeof $||null===$)throw"jQuery is not installed";$(function(){var t,n,i,o,s,a,r,l,u,h,c,d,p,m,f,E,w,y,T,g,v,z,k;if(h=.5,m=new THREE.Scene,s=new THREE.PerspectiveCamera(75,window.innerWidth/window.innerHeight,.1,1e3),f=document.getElementById("scene"),p=new THREE.WebGLRenderer({canvas:f}),p.setSize(window.innerWidth,window.innerHeight),r=new THREE.SphereGeometry(50,16,16),u=new THREE.MeshLambertMaterial({color:16711680}),a=new THREE.Mesh(r,u),a.position=new THREE.Vector3(0,0,0),m.add(a),v=document.getElementById("trackerCanvas"),z=document.getElementById("trackerVideo"),l=new headtrackr.Tracker({ui:!1,headPosition:!0,calcAngles:!1}),l.init(z,v),l.start(),c=new THREE.PointLight(255),c.position.x=10,c.position.y=50,c.position.z=130,m.add(c),s.position.z=500,s.position.y=50,s.lookAt(a.position),n=function(){function e(e,n,i){var o,s,a,r;for(this.scene=e,this.subject=n,this.count=i,this.flakes=new THREE.Geometry,this.material=new THREE.ParticleBasicMaterial({size:2,map:THREE.ImageUtils.loadTexture("assets/particle.png"),blending:THREE.AdditiveBlending,depthTest:!1,transparent:!0}),this.points=new THREE.GeometryUtils.randomPointsInGeometry(this.subject,this.count),o=a=0,r=this.count;r>=0?r>a:a>r;o=r>=0?++a:--a)s=new t(this.points[o],10),s.explode(),this.flakes.vertices.push(s);return this.system=new THREE.ParticleSystem(this.flakes,this.material),console.log(this.flakes),this.system.sortParticles=!0,console.log(this.flakes),this.scene.add(this.system),console.log(this.flakes),this}return e.prototype.flake=function(){var t,e,n,i,o;for(i=this.flakes.vertices,o=[],e=0,n=i.length;n>e;e++)t=i[e],o.push(t.flake());return o},e.prototype.explode=function(){var t,e,n,i;for(i=this.flakes.vertices,e=0,n=i.length;n>e;e++)t=i[e],t.explode(2500).animate();return this.onAnimationEnd(),this},e.prototype.implode=function(){var t,e,n,i;for(i=this.flakes.vertices,e=0,n=i.length;n>e;e++)t=i[e],t.implode(2500).animate();return this.onAnimationEnd(),this},e.prototype.onAnimationEnd=function(){},e}(),t=function(t){function n(t,e){var n=this;return null==e&&(e=2),this.velocity=new THREE.Vector3(0,-Math.random()+1,0),this.animation=null,this.x=t.x,this.y=t.y,this.z=t.z,this.implodeSet={x:this.x,y:this.y,z:this.z},this.explodeSet={x:this.x*e,y:this.y*e,z:this.z*e},this.explodeTween=new TWEEN.Tween(this).to(this.explodeSet,2500).easing(TWEEN.Easing.Elastic.Out),this.flakeTween=new TWEEN.Tween(this).to({y:-200},800),this.implodeTween=new TWEEN.Tween(this).to(this.implodeSet,2500).easing(TWEEN.Easing.Elastic.Out),this.explodeTween.onComplete(function(){return n.flake}),this.flakeTween.onComplete(function(){return n.y=200,n.animation?n.animation.chain(n.flakeTween):n.animation=n.flakeTween.start()}),this}return e(n,t),n.prototype.explode=function(){return this.animation?this.animation.chain(this.explodeTween):this.animation=this.explodeTween.start(),this},n.prototype.implode=function(){return this.animation=this.implodeTween.start(),this},n.prototype.flake=function(){return this.animation.chain(this.flakeTween),this},n.prototype.animate=function(){return this.animation&&this.animation.start(),this},n}(THREE.Vector3),i=1500,w=new n(m,r,i),o=1,$(document).click(function(){return 1===o?(w.explode(),o=0):(w.implode(),o=1)}),"undefined"==typeof buzz||null===buzz)throw"Buzz is not installed";return E={preload:!0,autoplay:!1,loop:!0},y=new buzz.sound("assets/loop1.wav",E),T=new buzz.sound("assets/loop2.wav",E),g=new buzz.sound("assets/loop3.wav",E),buzz.all().bindOnce("canplaythrough",function(){return console.log("canplaythrough"),buzz.all().play()}),y.setVolume(100),T.setVolume(20),g.setVolume(0),buzz.all(),d=function(){return TWEEN.update(),w.system.rotation.y+=.01,requestAnimationFrame(d),p.render(m,s)},d(),k={getUserMedia:"You got that camera","no getUserMedia":"u shy ? Turn that camera on...","camera found":"Camera is working","no camera":"Hey, u dat shy ?",detecting:"Don't hide, tryin to find u...",found:"Gotcha ! You can move now :)",lost:"Hey !! Where are ya ??",redetecting:"Tryin to find you again"},document.addEventListener("headtrackrStatus",function(t){return t.status in k?console.log(k[t.status]):void 0}),document.addEventListener("facetrackingEvent",function(t){var e,n;return e=h=t.x/320,n=t.y/240,new TWEEN.Tween(s.position).to({x:200*-e,y:200*n},980).easing(TWEEN.Easing.Cubic.Out).onUpdate(function(){}).start(),y.setVolume(100*e),T.setVolume(100-100*e),g.setVolume(100-150*e)}),window.camera=s})}.call(this);