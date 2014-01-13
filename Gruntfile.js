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
            build: {
                options: {
                    src: 'jekyll'
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

        xsltproc: {
            options: {
                stylesheet: 'cv/cv-html.xsl',
                novalid: true
            },
            compile: {
                files: {
                    'jekyll/_includes/cv.html': ['cv/brunopaulin.xml']
                }
            }
        }
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-xsltproc');

    grunt.registerTask("default", ["xsltproc", "jekyll:build", "htmlmin"]);
    grunt.registerTask("travis", ["xsltproc", "jekyll:build", "htmlmin", "validation"]);
};