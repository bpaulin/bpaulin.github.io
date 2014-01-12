module.exports = function(grunt) {

    grunt.initConfig({
        validation: {
            options: {
                reset: true,
                failHard: true,
                relaxerror: ["Bad value X-UA-Compatible for attribute http-equiv on element meta."]
            },
            files: {
                src: ['_site/**/*.html']
            }
        },

        jekyll: {                            
            docs: {}
        },

        htmlmin: {                                     // Target
              options: {                                 // Target options
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

    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks("grunt-jekyll");
    grunt.loadNpmTasks('grunt-contrib-htmlmin');

    grunt.registerTask("default", ["jekyll"]);
    grunt.registerTask("travis", ["jekyll", "htmlmin", "validation"]);
};