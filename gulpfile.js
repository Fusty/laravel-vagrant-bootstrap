var gulp = require('gulp'),
    plumber = require('gulp-plumber'),
    gutil = require('gulp-util'),
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    lr = require('tiny-lr'),
    gulp = require('gulp'),
    livereload = require('gulp-livereload'),
    server = lr();

gulp.task('sass', function() {
     return gulp.src('app/assets/sass/main.scss')
         .pipe(sass({ style: 'compressed', errLogToConsole: true }))
         .pipe(autoprefixer('last 15 version'))
         .pipe(gulp.dest('public/css'))
         .pipe(livereload(server));
});

gulp.task('default', function() {
    server.listen(35729, function(err){
        if(err) return console.log(err);

        gulp.watch('app/assets/sass/**/*.scss', function() {
            gulp.run('sass');
        });
    });
});