const { description } = require('../../package')

module.exports = {
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#title
   */
  title: 'Bpaulin.net',
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#description
   */
  description: description,

  /**
   * Extra tags to be injected to the page HTML `<head>`
   *
   * ref：https://v1.vuepress.vuejs.org/config/#head
   */
  head: [
    ['meta', { name: 'theme-color', content: '#3eaf7c' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }]
  ],

  theme: '@vuepress/blog',
  themeConfig: {
    // Please head documentation to see the available options.
    dateFormat: 'YYYY-MM-DD',
    nav: [
      {
        text: 'Articles',
        link: '/',
      },
      {
        text: 'About',
        link: '/about/',
      },
      {
        text: 'Resume',
        link: '/resume/',
      },
    ],
    footer: {
      contact: [
        {
          type: 'github',
          link: 'https://github.com/bpaulin',
        },
        {
          type: 'linkedin',
          link: 'https://www.linkedin.com/in/bpaulin-devops',
        },
      ],
    },
  },

  /**
   * Apply plugins，ref：https://v1.vuepress.vuejs.org/zh/plugin/
   */
  plugins: [
    '@vuepress/plugin-back-to-top',
    '@vuepress/plugin-medium-zoom',
    [
      '@vuepress/blog',
      {
        directories: [
          {
            // Unique ID of current classification
            id: 'post',
            // Target directory
            dirname: '_posts',
            // Path of the `entry page` (or `list page`)
            path: '/',
            itemPermalink: '/articles/:year/:month/:day/:slug',
          },
        ],
      },
    ],
    [
      '@vuepress/google-analytics',
      {
        'ga': 'UA-46867580-1'
      }
    ]
  ]
}
