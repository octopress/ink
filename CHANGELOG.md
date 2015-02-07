# Changelog

### 1.0.0 RC39 - 2015-02-07
- New: Octopress Page assets have methods for accessing the plugin and asset that generated them.

### 1.0.0 RC38 - 2015-02-05
- Fix: Plugin asset paths were improperly generated.

### 1.0.0 RC37 - 2015-01-31

- Added `clone` method to page assets.
- Pages now list permalink settings in `ink list` view.
- Refactored page permalink system.

### 1.0.0 RC36 - 2015-01-31

- Fix: Octopress Hooks now fire properly on page assets.

### 1.0.0 RC35 - 2015-01-28

- Fix: Includes nested in sub directories work again. [#40](https://github.com/octopress/ink/issues/40)

### 1.0.0 RC34 - 2015-01-28

- Fix: Don't attempt to remove cached assets if they don't exist.

### 1.0.0 RC33 - 2015-01-28

- Fix: Doesn't assume site plugin path is in site source directory. Thanks [@drallgood](https://github.com/octopress/feeds/issues/10)!

### 1.0.0 RC32 - 2015-01-26

- Minor change: Moved plugin requiring out to Octopress gem.

### 1.0.0 RC31 - 2015-01-26

- Fix: Sass partials in subdirectories aren't added to asset pipeline.
- Fix: Now copies assets in subdirectories into correct paths.
- Fix: Plugins are now loaded via Jekyll's plugin manager

### 1.0.0 RC30 - 2015-01-22

- Added `set_lang` placeholder so plugins can easily integrate with [octopress-multilingual](https://github.com/octopress/multilingual).

### 1.0.0 RC29 - 2015-01-14

- Fixed path issues when writing stylesheet tags.

### 1.0.0 RC28 - 2015-01-14

- Minified javascripts (whatever.min.js) are not re-compressed and are added first in the builds

### 1.0.0 RC27 - 2015-01-12

- Fixed: Invisible "dot" files are now ignored as plugin assets. [#32](https://github.com/octopress/ink/issues/32)

### 1.0.0 RC26 - 2015-01-09

- Fixed: Issue where setting destination config would break Jekyll cleaner.

### 1.0.0 RC25 - 2015-01-06

- Now loading octopress-include-tag properly.

### 1.0.0 RC24 - 2015-01-04

- Added gem name metadata to plugin scaffold

### 1.0.0 RC23 - 2015-01-02

- Reworked integration with Octopress Docs

### 1.0.0 RC22 - 2015-01-01

- Moved Asset pipeline configuration under `asset_pipline` key in _config.yml 

### 1.0.0 RC21 - 2014-12-13

- Documentation fixes

### 1.0.0 RC20 - 2014-12-13

- Improvements to scaffold and docs.

### 1.0.0 RC19 - 2014-12-09

- Fixes to be compatible with the latest versions of Octopress and Jekyll.

### 1.0.0 RC18 - 2014-10-07

- Improved integration with octopress-docs for displaying plugin documentation.

### 1.0.0 RC17 - 2014-09-01

- Fixed issue where Sass required a `_plugins/[plugin]/stylesheets` directory.

### 1.0.0 RC16 - 2014-08-21

- New: Access the url for a plugin's page from anywhere with `{{ theme.permalinks.page_name }}` or `{{ plugins.pugin-name.permalinks.page_name }}`.
- Fix: Properly invalidate caches for `jekyll build --watch` support.

### 1.0.0 RC15 - 2014-08-17

- Fixed an issue where Octopress would trigger site_payload too early. 

### 1.0.0 RC14 - 2014-08-11

- Reworked asset methods

### 1.0.0 RC13 - 2014-08-11

- Fixed an issue with asset tags

### 1.0.0 RC12 - 2014-08-03

- Extracted all tags to separate projects under [github.com/octopress](https://github.com/octopress).
- Now the only tag provided by default is [include-tag](https://github.com/octopress/include-tag).
- Switched from jekyll-page-hooks to octopress-hooks.
- Extracted link post feature as a separate plugin [octopress-linkblog](https://github.com/octopress/linkblog)
- Extracted page date feature as a separate plugin [octopress-date-format](https://github.com/octopress/date-format)
- Extracted Autoprefixer a separate plugin [octopress-autoprefixer](https://github.com/octopress/autoprefixer)

### 1.0.0 RC11 - 2014-06-27

- Fixed: Render tag properly processes local variables.

### 1.0.0 RC10 - 2014-06-26

- Render tag does a better job of preserving {% raw %} escaped content.

### 1.0.0 RC9 - 2014-06-21

- Added jekyll-page-hooks as a dependency.
- Now processing partials as ConvertiblePartials

### 1.0.0 RC8 - 2014-06-09

- Improved the way Ink manages the payload
- Added `linkposts` and `articles` methods to Ink

### 1.0.0 RC7 - 2014-06-08

- New: Added `excerpted` post var, true if post.excerpt is shorted than post.content.

### 1.0.0 RC6 - 2014-06-07

- Fixed: Gemspec scaffold does not include Ink's pre-release version numbers.
- Fixed: Better formatting for ordinal dates.
- Other minor bug fixes

### 1.0.0 RC5 - 2014-06-06

- New: site.linkposts loops through linkposts
- New: site.articles loops through non-linkpost articles

### 1.0.0 RC4 - 2014-05-28

- Improved: Plugin scaffold does a better job of handling gem names with dashes.

### 1.0.0 RC3 - 2014-05-27

- Improved: Now copy and list commands use the flag --config-file instead of --defaults

### 1.0.0 RC2 - 2014-05-26

- Fixed: Post and Page data is appended to at read time.

### 1.0.0 RC1 - 2014-05-25

- Initial release candidate
