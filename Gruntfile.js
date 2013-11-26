'use strict';

module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        config: {
            app: 'app'
        },
        watch: {
            scripts: {
                files: ['**/*.js'],
                tasks: ['jshint'],
                options: {
                    spawn: false
                }
            }
        },
        php: {
            options:{
                keepalive: true,
                open:true
            },
            dist: {
                options: {
                    port: 5000
                }
            },
            watch: {
                files: '<%= config.app %>/**/*.php',
                options: {
                    livereload:true
                }
            }
        }
    });

    // Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-php');

    // Default task(s).
    grunt.registerTask('default', ['uglify']);
    grunt.registerTask('phpwatch', ['php:watch']);
};