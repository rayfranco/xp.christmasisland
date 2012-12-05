fs     = require 'fs'
spawn  = require('child_process').spawn
exec   = require('child_process').exec
flour  = require 'flour'

task 'setup', ->
	console.log 'Installing the dependencies...'
	exec 'bower install', (err, stdout, stderr) ->
		console.log stdout

task 'build:dev', ->
    compile 'src/main.coffee', 'app/main.js'

task 'build:prod', ->
    bundle [
      'vendor/threejs/index.js',
      'vendor/headtrackr/headtrackr.js',
      'src/main.coffee'
    ], 'app/main.js'

task 'package', ->
  bundle [
    'src/Ambiance.coffee',
    'src/Particle.coffee',
    'src/main.coffee'
  ], 'app/app.js'

task 'build', ->
	console.log 'Building the sources...'
	invoke 'build:dev'

task 'watch', ->
    invoke 'build'
    watch 'src/main.coffee', -> invoke 'build'