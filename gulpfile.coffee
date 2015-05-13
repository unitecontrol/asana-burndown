fs = require 'fs'
path = require 'path'

gulp = require 'gulp'
rsync = require 'gulp-rsync'

gulp.task 'deploy', ->
	gulp.src(['./package.json', 'src'])
		.pipe rsync
			destination: '/var/www/uc-burndown/'
			hostname: 'uc_burndown'
			incremental: true
			progress: true
			relative: true
			emptyDirectories: true
			recursive: true
			clean: true
			exclude: ['.DS_Store']
			include: []
