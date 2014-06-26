# Changelog

## Current released version

### 1.0.0 RC11 - 2014-06-27

- Fixed: Render tag properly processes local variables.

## Past versions

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
