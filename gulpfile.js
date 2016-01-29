var gulp = require('gulp');
var coffee = require('gulp-coffee');
var beautify = require('gulp-beautify');
var watch = require('gulp-watch');

gulp.task('coffee', function () {
    return gulp.src('./src/**/*.coffee')
        .pipe(coffee())
        .pipe(beautify({
            indentSize: 2
        }))
        .pipe(gulp.dest('./'));
});

gulp.task('watch', function () {
    gulp.watch('./src/**/*.coffee', ['coffee']);
});

gulp.task('build', ['coffee']);

gulp.task('default', ['coffee', 'watch']);
