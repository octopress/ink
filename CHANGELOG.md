# Changelog

### 1.2.1 (2015-09-07)
- Fix: For bootstrap pages, titles no longer include site url. That should be handled by templates.

### 1.2.0 (2015-06-26)
- New: you can configure output destinations for asset pipeline stylesheets and javascripts.

### 1.1.4 (2015-05-18)
- Fix: Cache writes no longer trigger Jekyll watch.
- Fix: Cache writes happen after site builds.

### 1.1.3 (2015-05-17)
- Fix: Ink assets filters files which shouldn't be included like .hidden_file, emacs.backup~, etc

### 1.1.2 (2015-05-12)
- Use Jekyll Hooks if you got 'em.
- Now supporting Jekyll 2 & 3
- In Jekyll 3 Coffeescript is optional - Added a request to install the gem if a plugin uses it but it is not present.

### 1.1.1 (2015-05-11)
- Minor: Gemspec dependency updates.

### 1.1.0 (2015-05-03)
- New: Added support for asynchronous stylesheet loading. [#56](https://github.com/octopress/ink/pull/56)
- New: Now loading combined javascripts asynchronously by default.

## 1.0.0 - 2015-05-02
- Minor: Improved styling for Octopress Ink list command output.
- Minor: Fixed issue where changelog couldn't be processed by Octopress Docs.

### 1.0.0 RC64 - 2015-04-28
- Minor: Improved bundler integration
- Minor: Added short flags for ink list and ink copy subcommands.

### 1.0.0 RC63 - 2015-04-26
- New: Pages and Sass assets can read plugin config at {{ plugin.config_label }} instead of {{ plugins.plugin-name.config_label }}.

### 1.0.0 RC62 - 2015-04-25
- Fix: octopress-autoprefixer is a runtime dependencies, not a development dependency.

### 1.0.0 RC61 - 2015-04-25
- New: Added octopress-autoprefixer to runtime dependencies. Now plugins can expect prefix-free CSS.

### 1.0.0 RC60 - 2015-04-24
- Fix: New plugin gemspec has a proper regex for adding files.
- Fix: Plugins created when passing --path option get proper correct names.

### 1.0.0 RC59 - 2015-03-27
- Fix: Properly clean asset cache during Jekyll watch.

### 1.0.0 RC58 - 2015-03-27
- Fix: When assets are recompiled during Jekyll watch, their file fingerprints are refreshed.

### 1.0.0 RC57 - 2015-03-27
- Fix: Now asset pipeline is properly reset during Jekyll watch.
- Minor: Added caching to speed up category and tag liquid tags.

### 1.0.0 RC56 - 2015-03-22
- Fix: Tag links and lists weren't being output
- Fix: Tags and categories would throw errors if tags were used but plugin
  didn't have tag/category templates installed.
- Change: tag names:
  from `{% tags %}` -> `{% tag_links %}`
  from `{% categories %}` -> `{% category_links %}`

### 1.0.0 RC55 - 2015-03-14
- Added `ink_watch` site configuration, allowing plugin authors to add their plugin assets directory to Jekyll's watch list.

### 1.0.0 RC54 - 2015-03-10
- Added `new_page` method to page assets to mirror template functionality.
- Generated pages can now reference the asset instance that generated them.

### 1.0.0 RC53 - 2015-03-05
- Fix: Removed reference to debugger

### 1.0.0 RC52 - 2015-03-05
- Plugin Bootstrap's templates do a better job of outputting content based on site posts.

### 1.0.0 RC51 - 2015-03-04
- Fix: Plugin bootstrap only fires if Site has posts.
- Fix: Use double quotes for HTML attributes in liquid tags.

### 1.0.0 RC50 - 2015-03-04
- Improved information about disabled or overridden assets on `ink list plugin` commands
- Reworked plugin bootstrap to use templates instead of pages
- Removed page clone method (templates should be used for this)

### 1.0.0 RC49 - 2015-03-02
- New: Plugin bootstrap allows plugins to work with templates for post indexes and RSS feeds. Each with automatic support for multilingual sites.

Plugins can add pages and templates for:
- A post index
- A post archive
- A post RSS feed
- A link posts RSS feed (with octopress-linkblog)
- An articles RSS feed (with octopress-linkblog)
- A post RSS feed
- Category index pages
- Tag index pages
- Category RSS feeds
- Tag RSS feeds

The plugin bootstrap will automatically handle page titles, permalinks and generating multiple pages for each tag and category.
If a user installs octopress-multilingual, all pages will be replicated and filtered for each language.

### 1.0.0 RC48 - 2015-02-18
- Minor: Improved template asset info when listed with `octopress ink list [plugin]` command.

### 1.0.0 RC47 - 2015-02-18
- Fix: `octopress ink list [plugin]` triggers site read to ensure all plugins are ready to present info.
- Fix: Template page info improvements

### 1.0.0 RC46 - 2015-02-18
- Fix: Site reset triggers reset method on each plugin.

### 1.0.0 RC45 - 2015-02-18
- Fix: Plugins weren't being initialized properly due to a race condition

### 1.0.0 RC44 - 2015-02-18
- Fix: Plugins reset for each build, fixing builds with Jekyll's watch enabled.
- New: Added plugin templates for dynamically generating pages.

### 1.0.0 RC43 - 2015-02-16
- Fix: Multilingual configurations are deep merged with primary language config to allow for less unnecessary duplication.

### 1.0.0 RC42 - 2015-02-15
- New: Plugins can define order for stylesheet and javascript assets.

### 1.0.0 RC41 - 2015-02-13
- Fix: Properly copies pages without permalinks.
- Permalink configurations now allow directories and file extensions in config keys.

### 1.0.0 RC40 - 2015-02-08
- Improvements to ink list command output.
- Ensures plugins cannot be registered multiple times.

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

- Render tag does a better job of preserving `{% raw %}` escaped content.

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
