module.exports = function(grunt) {

    grunt.initConfig({
        validation: {
            options: {
                reset: true,
                reportpath: false,

                failHard: true,
                relaxerror: ["Bad value X-UA-Compatible for attribute http-equiv on element meta."]
            },
            files: {
                src: ['_site/**/*.html']
            }
        },

        jekyll: {                            
            build: {},
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

        xsltproc: {
            options: {
                stylesheet: '_includes/cv-html.xsl',
                novalid: true
            },
            compile: {
                files: {
                    '_includes/cv.html': ['apropos/brunopaulin.xml']
                }
            }
        }
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadTasks("./_includes/tasks");

    grunt.registerTask("default", ["xsltproc", "jekyll:build", "htmlmin"]);
    grunt.registerTask("travis", ["xsltproc", "jekyll:build", "htmlmin", "validation"]);
};