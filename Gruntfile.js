module.exports = function(grunt) {

    grunt.initConfig({
        validation: {
            options: {
                reset: true,
                reportpath: false,
                failHard: true,
                relaxerror: ["Bad value X-UA-Compatible for attribute http-equiv on element meta."]
            },
            src: ['_site/**/*.html']
        },

        jekyll: {
            build: {
                options: {
                    src: 'jekyll'
                }
            },
            serve: {
                options: {
                    src: 'jekyll',
                    watch: true,
                    serve: true
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

        watch: {
        },

        concurrent: {
            dev: ['watch', 'jekyll:serve'],
            options: {
                logConcurrentOutput: true
            }
        }
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-xsltproc');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-concurrent');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-shell');

    grunt.registerTask("default", ["shell:xmllint", "xsltproc", "shell:pdf", "shell:pdfanonyme", "jekyll:build", "htmlmin"]);
    grunt.registerTask("dev", ["concurrent:dev"]);
    grunt.registerTask("travis", ["jekyll:build", "htmlmin", "validation"]);
};
