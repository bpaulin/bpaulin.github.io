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
        },

        watch: {
            xsltproc: {
                files: ['cv/brunopaulin.xml','cv/cv-html.xsl'],
                tasks: ['xsltproc']
            },
            xmllint: {
                files: ['cv/brunopaulin.xml'],
                tasks: ['shell:xmllint']
            },
            pdf: {
                files: ['cv/brunopaulin.xml','cv/cv-pdf.xsl'],
                tasks: ['shell:pdf']
            },
            less: {
                files: 'style/bpaulin.less',
                tasks: ['less']
            }
        },

        concurrent: {
            dev: ['watch', 'jekyll:serve'],
            options: {
                logConcurrentOutput: true
            }
        },

        less: {
            site: {
                files: {
                    "jekyll/css/bpaulin.css": "style/bpaulin.less"
                },
                options: {
                    cleancss: true
                }
            }
        },

        shell: {                    
            pdf: {        
                options: {             
                    stdout: true,
                    stderr: true,
                    failOnError: true
                },
                command: 'fop -xml cv/brunopaulin.xml -xsl cv/cv-pdf.xsl -pdf jekyll/apropos/brunopaulin.pdf'
            },              
            xmllint: {        
                options: {             
                    stdout: true,
                    stderr: true,
                    failOnError: true
                },
                command: 'xmllint --noout --postvalid --dtdvalid http://xmlresume.sourceforge.net/dtd/resume.dtd cv/brunopaulin.xml'
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

    grunt.registerTask("default", ["shell:xmllint", "xsltproc", "shell:pdf", "jekyll:build", "htmlmin"]);
    grunt.registerTask("dev", ["concurrent:dev"]);
    grunt.registerTask("travis", ["shell:xmllint", "xsltproc", "jekyll:build", "htmlmin", "validation"]);
};