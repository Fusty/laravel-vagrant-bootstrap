'use strict';

module.exports = function(grunt) {
    // Project configuration.
    grunt.initConfig({
        config: {
            app: 'app'
        },
        sass: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= config.app %>/assets/css',
                    src: ['*.scss'],
                    dest: 'public/css',
                    ext: '.css'
                }]
            }
        },
        compass: {
            options: {
                sassDir: '<%= config.app %>/assets/css',
                cssDir: '.tmp/styles',
                generatedImagesDir: '.tmp/images/generated',
                imagesDir: '<%= config.app %>/assets/images',
                javascriptsDir: '<%= config.app %>/assets/js',
                fontsDir: '<%= config.app %>/assets/fonts',
                importPath: 'bower_components',
                httpImagesPath: 'public/images',
                httpGeneratedImagesPath: 'public/images/generated',
                httpFontsPath: 'public/fonts',
                relativeAssets: false
            },
            dist: {},
            server: {
                options: {
                    debugInfo: true
                }
            }
        },
        watch: {
            sass: {
                files: ['<%= config.app %>/assets/css/{,*/}*.{scss,sass}'],
                tasks: ['sass:dist']
            },
            livereload: {
                options:{
                    livereload:true
                },
                files: [
                    '<%= config.app %>/views/{,*/}*.php',
                    '.tmp/styles/{,*/}*.css',
                    '<%= config.app %>}/public/css/{,*/}*.css',
                    '<%= config.app %>/public/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
                    '<%= config.app %>/**/*.php'
                ]
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
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-php');

    // Default task(s).
    grunt.registerTask('default', ['uglify']);
    //grunt.registerTask('phpwatch', ['php:watch']);
};