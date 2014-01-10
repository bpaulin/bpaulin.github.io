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
        }

    });

    grunt.loadNpmTasks("grunt-html-validation");
    grunt.loadNpmTasks("grunt-jekyll");

    grunt.registerTask("default", ["jekyll"]);
    grunt.registerTask("travis", ["jekyll", "validation"]);
};