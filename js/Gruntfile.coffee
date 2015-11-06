module.exports = (grunt) ->
  # Project configuration
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    uglify:
      options:
        banner: "/* <%= pkg.name %> <%= pkg.version %> -- built on " \
          + "<%= grunt.template.today('yyyy-mm-dd hh:MM:ss') %> */\n"
      build:
        src: "dist/<%= pkg.name %>.js"
        dest: "dist/<%= pkg.name %>.min.js"
    browserify:
      main:
        options:
          browserifyOptions:
            standalone: "RiveScript"
        src: "index.js",
        dest: "dist/rivescript-rsgb.js"
    nodeunit:
      all: ["test/test-*.coffee"]
      options:
        reporter: "default"
    clean: ["dist/"]

  # Grunt plugins
  grunt.loadNpmTasks("grunt-contrib-coffee")   # CoffeeScript compiler
  grunt.loadNpmTasks("grunt-browserify")       # Browserify
  grunt.loadNpmTasks("grunt-contrib-uglify")   # Minify JS
  grunt.loadNpmTasks("grunt-contrib-nodeunit") # Unit testing
  grunt.loadNpmTasks("grunt-contrib-clean")    # Clean up build files

  # Tasks
  grunt.registerTask "default", ["nodeunit"]
  grunt.registerTask "dist", ["browserify", "uglify"]
  grunt.registerTask "test", ["nodeunit"]
