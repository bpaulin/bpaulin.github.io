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
                    src: '.',
                    bundleExec: true
                }
            },
            serve: {
                options: {
                    src: '.',
                    watch: true,
                    serve: true,
                    drafts: true,
                    bundleExec: true
                }
            },
        },
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks('grunt-w3c-html-validation');

    grunt.registerTask("dev", ["jekyll:serve"]);
    grunt.registerTask("ci", ["jekyll:build", "validation"]);
};
