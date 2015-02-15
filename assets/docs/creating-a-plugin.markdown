---
title: "Create an Octopress Ink Plugin"
permalink: /ink/creating-a-plugin/
---

*This guide assumes you have already installed Git, and have Ruby 1.9.3 or greater.*

Octopress Ink plugins are distributed as ruby gems so you'll need to create an account at [RubyGems.org](https://rubygems.org/sign_up) if you haven't yet. Also, be sure to install the [Bundler](http://bundler.io) gem.

## Creating a plugin

Creating an Octopress Ink plugin is very simple. Here's the standard template.

```ruby
require "octopress-ink"

Octopress::Ink.add_plugin({
  name:          "My Plugin",
  slug:          "my-plugin",
  gem:           "my-plugin",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "../")),
  type:          "plugin",

  # Metadata which is displayed with plugin info
  version:       MyPlugin::VERSION,
  description:   "My plugin does awesome stuff",
  source_url:    "https://github.com/user/project",
  website:       ""                                
})
```

The configuration options are as follows.

| Configuration | Description |
|:--------------|:------------|
| name          | The display name for your plugin, e.g. "My Plugin" |
| path          | Path to your plugin's root directory | 
| slug          | Optional: The slug is how users will reference your plugin, (Default: sluggified name) |
| gem           | Optional: This is displayed in plugin info and on the local docs site. |
| type          | Optional: "plugin" or "theme" (Default: "plugin") |
| version       | Optional: Version will be displayed with plugin info |
| description   | Optional: Description will be displayed with plugin info |
| website       | Optional: Website will be displayed with plugin info |
| source_url    | Optional: Direct people to the GitHub project (or elsewhere) |

Note: For themes, the slug will be set to `theme`. This makes it easy for users to work with any theme with a consistent slug name.

Next you simply need an `assets` directory at the root of your gem with subdirectories for each asset type you plan to use in your plugin.

If you have a gem-based plugin which you'd like to convert into an Octopress Ink plugin, this should make it easy for you.

```sh
$ octopress ink init your_gem
```

This will add the asset directories, create a demo site, and print out a plugin template with instructions for how to add it to your gem.

### Create a plugin from scratch

To create a new plugin named "Some Plugin" run:

```sh
$ octopress ink new some_plugin
```

This does the following.

- Creates a new gem using Bundler's gem scaffolding.
- It adds `octopress` and `octopress-ink` as dependencies in the gemspec.
- An Octopress Ink plugin template is added to `lib/some_plugin.rb`.
- `assets/` contains empty asset directories.
- `demo/` contains a blank Jekyll site with your plugin already integrated for easy testing.

Here's what the new `some_plugin` directory looks like.

```
assets/
  docs/
  files/
  fonts/
  images/
  includes/
  javascripts/
  layouts/
  pages/
  stylesheets/
lib/
  some_plugin/
    version.rb
  some_plugin.rb
demo/
  _layouts/
  _posts/
  Gemfile
  index.html
some_plugin.gemspec
Gemfile
LICENSE.txt
Rakefile
README.md
```

In `lib/some_plugin.rb` you'll find an Octopress Ink plugin created specifically for your gem.

```ruby
require 'lib/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Some Plugin",
  slug:          "some-plugin",
  gem:           "some-plugin",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "..")),
  type:          "some_plugin",
  version:       SomePlugin::Version,
  description:   "",
  website:       "",
  source_url:    ""
})
```

Change whatever you want and you are ready to start building your plugin.

### Building on an existing plugin

If you're going to convert an existing gem-based Jekyll plugin to use Octopress Ink, from your gem directory run:

```sh
$ octopress ink init .
```

This will add the assets directories and the demo site to your
plugin. To finish setting up your plugin, you'll need to add the plugin template to your gem.

## Plugin assets

Octopress Ink plugins make it super easy to integrate assets with any Jekyll site. Your plugin should have an `assets` directory,
typically in the root directory of your gem. Inside `assets` there will be folders for each asset type your plugin uses plan to use.

Note: Assets are copied at build time and assets will not overwrite an existing file.

| Asset directory |  Description                                    |
|:----------------|:------------------------------------------------|
| layouts         | Users can add layouts by setting `layout: plugin_slug:some_layout` in a page's YAML front-matter.     |
| includes        | Includes are available to users by `{% include plugin_slug:some_file.html %}`.   |
| pages           | `pages/feed.xml` is processed and copied to `_site/feed.xml` at build time. Setting `permalink: feed/` renders to `_site/feed/index.xml`. |
| files           | `files/favicon.ico` is copied to `_site/favicon.ico`.                                                   |
| fonts           | `wingdings.ttf` is copied to `_site/fonts/plugin_slug/wingdings.ttf`.                                 |
| images          | `cat.gif` is copied to `_site/images/plugin_slug/cat.gif`.                                            |
| javascripts     | `boom.js` is combined with all plugin javascripts into a single fingerprinted file.                     |
| stylesheets     | `theme.scss` and `print.css` are combined with all plugin stylesheets into a single fingerprinted file. |
| docs            | Add documentation files for your plugin here. Users will be able to read it by running `octopress docs`. |

### Ordering Javascript and Stylesheet assets

By default when scripts and stylesheets are combined, they are added based on
their order in the file system. You can manually specify order like this:

```
order_js:
 - jquery.js
 - kittens.coffee

order_css:
 - normalize.css
 - site.sass
```
Assets will ordered as specified. Any additional assets will be appended based on their order in the file system.

Note: It is not necessary to write full paths in these configurations. An asset at `javascripts/lib/jquery.js` will match `jquery.js` and be ordered accordingly.


### Layouts

Layouts will probably mostly be useful if you're developing a theme. For a typical theme you'll probably have three layouts:

```
assets/
  layouts/
    default.html
    page.html
    post.html
```

Here's a example of a simple `default.html` layout.

```
<!DOCTYPE html>
<meta charset="utf-8">
<html>
  <head>
    <title>{{ page.title }} - {{ site.title }}</title>
    {% css_asset_tag %}
  </head>
  <body>
    {{ content }}
    {% js_asset_tag %}
  </body>
</html>
```

You'll notice the `{% css_asset_tag %}` and `{% js_asset_tag %}` tags. These are special tags that come with Octopress Ink and output the `<link>` and `<script>` tags from the Octopress Ink asset pipeline.

A `page.html` or `post.html` might look like this:

```
---
layout: theme:default
---
<article>
<h1>{{ page.title }}</h1>
{{ content }}
</article>
```

You'll notice that the default layout is included with `layout: theme:default`. Of course, if your plugin's slug was `baconnaise` you'd use `layout: baconnaise:default`.

Users can override the theme's default layout by adding a file to `_plugins/theme/layouts/default.html`. Now the theme's page and post layouts will 
load the user's default layout instead of loading it from the theme's assets. If your plugin's slug was `baconnaise` the user could override the layout by placing a
file at `_plugins/baconnaise/layouts/default.html`.

### Includes

Includes are how you store a partial of code to be reused in several locations. For example, you might want to share site navigation between several layouts.

```
assets/
  includes/
    navigation.html
```

To include this partial, use an include tag, but add the plugin slug before the filename like this `{% include plugin_slug:navigation %}`.
