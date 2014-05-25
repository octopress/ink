require './test_suite'
ENV['JEKYLL_ENV'] = 'test'

@failures = []

build

test_dirs('Site build', 'site', 'expected')

build({octopress_config: '_combine_false.yml'})

test_dirs("Don't combine CSS", 'site/stylesheets', 'combine_css_false/stylesheets')
test_dirs("Don't combine JS", 'site/javascripts', 'combine_js_false/javascripts')

build({octopress_config: '_uglify_js_false.yml'})

test_dirs("Don't uglify JS", 'site/javascripts', 'uglify_js_false/javascripts')

test_cmd({
  desc: 'Copy all theme assets',
  cmd: 'octopress ink copy theme --path _copy --force',
  expect: 'Copied files:
+ source/_copy/layouts/default.html
+ source/_copy/layouts/test.html
+ source/_copy/includes/bar.html
+ source/_copy/includes/greet.html
+ source/_copy/pages/disable-test.html
+ source/_copy/pages/four.xml
+ source/_copy/pages/one.xml
+ source/_copy/pages/three.md
+ source/_copy/pages/two.md
+ source/_copy/stylesheets/_colors.scss
+ source/_copy/stylesheets/disable.sass
+ source/_copy/stylesheets/main.scss
+ source/_copy/stylesheets/disable-this.css
+ source/_copy/stylesheets/theme-media-test@print.css
+ source/_copy/stylesheets/theme-test.css
+ source/_copy/stylesheets/theme-test2.css
+ source/_copy/javascripts/bar.js
+ source/_copy/javascripts/disable-this.js
+ source/_copy/javascripts/foo.js
+ source/_copy/javascripts/blah.coffee
+ source/_copy/fonts/font-one.otf
+ source/_copy/fonts/font-two.ttf
+ source/_copy/files/disabled-file.txt
+ source/_copy/files/favicon.ico
+ source/_copy/files/favicon.png
+ source/_copy/files/test.html
+ source/_copy/config.yml'
})

test_dirs('Copy theme', 'source/_copy', 'copy_test/_copy')
`rm -rf source/_copy`

test_cmd({
  desc: 'Copy theme layouts and pages',
  cmd: 'octopress ink copy theme --layouts --pages --path _copy --force',
  expect: 'Copied files:
+ source/_copy/layouts/default.html
+ source/_copy/layouts/test.html
+ source/_copy/pages/disable-test.html
+ source/_copy/pages/four.xml
+ source/_copy/pages/one.xml
+ source/_copy/pages/three.md
+ source/_copy/pages/two.md'
})

test_dirs('Copy theme', 'source/_copy', 'copy_layouts_pages/_copy')
`rm -rf source/_copy`

print_results
