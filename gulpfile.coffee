gulp        = require 'gulp'
concat      = require 'gulp-concat'
browserify  = require 'gulp-browserify'
zip         = require 'gulp-zip'
jeditor     = require 'gulp-json-editor'

Package     = require './package.json'

project =
  dist:         './dist'
  build:        './build'
  src:          './src/**/*.coffee'
  static:       './static/**'
  assets_src:   './app_assets/**'
  assets_dest:  './build/app_assets'
  manifest:     './manifest.json'

gulp.task 'default', ['pack']
gulp.task 'build', ['src', 'app_assets', 'static', 'manifest']

gulp.task 'src', ->
  gulp.src('./src/index.coffee',  read: false)
    .pipe(browserify({
      transform:  ['coffeeify']
      extensions: ['.coffee']
    }))
    .pipe(concat('app.js'))
    .pipe(gulp.dest(project.build))

gulp.task 'static', ->
  gulp.src(project.static)
    .pipe(gulp.dest(project.build))

gulp.task 'app_assets', ->
  gulp.src(project.assets_src)
    .pipe(gulp.dest(project.assets_dest))

gulp.task 'manifest', ->
  gulp.src(project.manifest)
    .pipe(jeditor((json) ->
      json.version = Package.version
      json
    )).pipe(gulp.dest(project.build))

gulp.task 'pack', ['build'], ->
  gulp.src("#{project.build}/**")
    .pipe(zip("#{Package.name}-#{Package.version}.zip"))
    .pipe(gulp.dest(project.dist))
