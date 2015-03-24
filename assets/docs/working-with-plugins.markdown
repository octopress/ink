---
title: "Working with Octopress Ink Plugins"
permalink: /working-with-plugins/
---

## Installing plugins

Octopress Ink plugins are distributed as Ruby gems. This makes them really easy to add to any Jekyll site.
If you were going to install the [octopress-codefence](https://github.com/octopress/codefence) plugin, first you'd need to install the gem.

#### Using Bundler

If you are using [Bundler](http://bundler.io), simply add it to your Gemfile in the `:jekyll_plugins` group and run `bundle`. Octopress will automatically load the plugin when you build your site.

```ruby
group :jekyll_plugins do
  gem 'octopress-codefence'
end
```

#### Manually

If you aren't using Bundler, first install the gem manually.

```sh
$ gem install octopress-codefence
```

Then add it to your gems list in your `_config.yml`.

```
gems:
  - octopress-codefence
```

Now whenever you build your site, Jekyll will automatically load the Octopress Codefence plugin.

## Listing plugins

If you have installed the `octopress` gem. You can easily learn about the plugins you have installed.

```
$ octopress ink list [PLUGIN] [options]        # List basic info about all installed plugins.
$ octopress ink list --all                     # List detailed info about all plugins.
$ octopress ink list --stylesheets             # List stylesheets from all plugins with stylesheets.
$ octopress ink list awesome-plugin            # List everything about a specific plugin.
$ octopress ink list awesome-plugin --layouts  # List layouts from a specific plugin.
$ octopress ink list theme --config            # List your theme's default configuration opitons.
```

Here's an example of what `octopress ink list` might print with `octopress-codefence` and `octopress-solarized` installed.

```
Octopress Ink - v1.0.0.0
 Octopress Codefence (octopress-codefence) - v1.0.1 - Generate beautiful code snippets with advanced features on any Jekyll site.
 Octopress Solarized (octopress-solarized) - v1.0.0 - Style code snippets with Ethan Schoonover's Solarized theme (tweaked a bit).
```

This lists the Octopress Ink version and each plugins along with some basic information. Here are some of the commands you can use. Run
`octopress ink list --help` to see all of the options.

Here's an example of the output from running `octopress ink list awesome-plugin`.

```
Plugin: Some Awesome Theme
Slug: theme
This theme is the awesome one.
================================================================================
 layouts:
  - default.html
  - post.html
  - page.html

 includes:
  - navigation.html
  - header.html
  - footer.html

 pages:
  - feed.xml                           /feed/index.html
  - index.html                         /index.html
  - archive.html                       /archives/index.html

 sass:
  - _colors.scss
  - _layout.scss
  - theme.scss

 files:
  - favicon.ico
```

## Customizing plugins

Assets for Octopress Ink plugins (templates, images, stylesheets, etc.) all live inside the gem and are
only integrated with your site during the build process. Here's how you can customize a plugin's assets.

Each plugin has a slug, for a theme this slug is always `theme`, but for other plugins it will be different. Run `octopress ink list` and
the plugin slugs will be listed after the plugin's name inside the parenthesis. Octopress Ink will look in `_plugins/[your_plugin_slug]/` for your plugin customizations.

For example, If you want to override the `default.html` layout for a theme, you'd add a file in your site's source directory at
`_plugins/theme/layouts/default.html`. Now when your site is built, Octopress Ink will override the theme's default layout with your
custom version.

The easiest way to make changes to a theme is to copy its assets into your override directories and make changes there.

### Copying plugin assets

If you have installed the `octopress` gem. You can copy a plugin's assets to it's corresponding override directory using the `octopress
ink copy` command. Here are some examples.

```
$ octopress ink copy <PLUGIN> [options]
$ octopress ink copy theme                     # Copy all theme assets to _plugins/theme/.
$ octopress ink copy theme --stylesheets       # Copy theme Sass or CSS to _plugins/theme/stylesheets/.
$ octopress ink copy theme --config            # Copy the theme's configuration file to _plugins/theme/config.yml.
$ octopress ink copy magic-plugin --layouts    # Copy layouts for magic-plugin to _plugin/magic-plugin/layouts/.
$ octopress ink copy magic-plugin --path test  # Copy all assets for magic-plugin to ./test
```

To make modifications to the default layout for your theme you might.

1. Run `octopress ink copy theme --layouts`.
2. Go to `_plugins/theme/layouts/` and remove all files except `default.html`.
3. Make necessary modifications to `default.html`.

If you decide that you want to revert to the original layout, simply remove your overriding copy and Octopress Ink will read the layout
from the gem once again.

This same system works for any type of asset listed with the `octopress ink list` command.

### Disabling plugin assets

You can disable assets from your plugin's configuration file. Disable individual assets, or all of one type of asset. Here's an example of how to disable assets on a theme.

```yaml
# _plugins/theme/config.yml
disable:
  fonts: true                          # disable all fonts
  files: favicon.ico                   # disable a specific file
  pages:                               # disable multiple pages
    - archive.html
    - feed.xml
```

Any asset can be disabled except for layouts, includes and Sass partials. Layouts and includes are only added to a site when you manually
include them, so disabling them isn't necessary. Sass partials can't be disabled because they aren't added directly to Jekyll,
but are instead included by Sass files.

You can verify that you've disabled assets by running `octopress ink list <PLUGIN>`. Assets which are disabled will be marked like this.

```
 fonts:  
  - awesome.ttf                   disabled
  - awesome.woff                  disabled
  - awesome.eot                   disabled

 files:
  - favicon.ico                   disabled
  - robots.txt         

 pages:
  - archive.html                  disabled
  - feed.xml                      disabled
  - index.html                    /index.html
```

### Changing URLs for plugin pages

You can override URLs for plugin pages in your plugin's configuration. Under `page_permalinks` add the file's name (not including the extension) as a key, followed by
your custom permalink. Here's an example.

```
page_permalinks:
  index: posts/        # index.html is moved to /posts/index.html
  feed: rss/           # feed.xml is moved to /rss/index.xml
```

Now when you run `octopress ink list <PLUGIN> --pages` you'll see your custom URLs listed by the pages.

```
 pages:
  - archive.html                  /archive.html
  - feed.xml                      /rss/index.xml
  - index.html                    /posts/index.html
```


