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
        }
    });

    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks('grunt-contrib-htmlmin');

    grunt.registerTask("default", ["jekyll:build", "htmlmin"]);
    grunt.registerTask("travis", ["jekyll:build", "htmlmin", "validation"]);
};