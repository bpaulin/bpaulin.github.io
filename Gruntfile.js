module.exports = function(grunt) {

    grunt.initConfig({
        validation: {
            options: {
                reset: true,
                reportpath: false,
                failHard: true,
                generateReport: false
            },
            src: ['_site/**/*.html']
        },

        jekyll: {
            build: {
                options: {
                    src: '.'
                }
            },
            serve: {
                options: {
                    src: '.',
                    watch: true,
                    serve: true,
                    drafts: true
                }
            },
        },

        htmlmin: {
            options: {
                removeComments: true,
                collapseWhitespace: true
            },
            files: {
                expand: true,
                src: ['**/*.html'],
                dest: '_site/',
                cwd: '_site/'
            }
        },
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks('grunt-w3c-html-validation');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');

    grunt.registerTask("dev", ["jekyll:serve"]);
    grunt.registerTask("ci", ["jekyll:build", "htmlmin", "validation"]);
};
