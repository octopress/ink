---
title: "Create an Octopress Ink Plugin"
permalink: /guides/creating-a-plugin/
---

*This guide assumes you have already installed Git, and Ruby 1.9.3 or greater.*

Octopress Ink plugins are distributed as ruby gems so you'll need to create an account at [RubyGems.org](https://rubygems.org/sign_up) if you haven't yet. Also, be sure to install the [Bundler](http://bundler.io) gem.

## Creating a plugin

Creating an Octopress Ink plugin is very simple. Here's the standard template.

{% render ./_plugin-template.markdown %}

The configuration options are as follows.

{% render ./_configuration.markdown %}

Next you simply need an `assets` directory at the root of your gem with subdirectories for each asset type you plan to use in your plugin.

If you have a gem-based plugin which you'd like to convert into an Octopress Ink plugin, this should make it easy for you.

```sh
$ octopress ink init your_gem
```

This will add the asset directories, create a demo site, and print out a plugin template with instructions for how to add it to your gem.

### Create a plugin from scratch

To create a new plugin named "Spicy Baconnaise" run:

```sh
$ octopress ink new spicy_baconnaise
```

This does the following.

- Creates a new gem using Bundler's gem scaffolding.
- It adds `octopress` and `octopress-ink` as dependencies in the gemspec.
- An Octopress Ink plugin template is added to `lib/spicy_baconnaise.rb`.
- `assets/` contains empty asset directories.
- `demo/` contains a blank Jekyll site with your plugin already integrated for easy testing.

Here's what the new `spicy_baconnaise` directory looks like.

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
  spicy_baconnaise/
    version.rb
  spicy_baconnaise.rb
demo/
  _layouts/
  _posts/
  Gemfile
  index.html
spicy_baconnaise.gemspec
Gemfile
LICENSE.txt
Rakefile
README.md
```

In `lib/spicy_baconnaise.rb` you'll find an Octopress Ink plugin created specifically for your gem.

```ruby
require 'lib/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Spicy Baconnaise"
  slug:          "spicy_baconnaise",
  assets_path:   File.expand_path(File.join(File.dirname(__FILE__), "../assets")),
  type:          "spicy_baconnaise",
  version:       SpicyBaconnaise::Version,
  description:   "",
  website:       ""
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

Octopress Ink plugins make it super easy to integrate assets with any Jekyll site. Your plugin should have an assets directory called `assets`. Typically this should be in the root directory of your gem. Inside `assets` there will be folders for each asset type you plan to use.

Note: Assets are only copied at build time and assets will not overwrite an existing file.


| Asset directory |  Description                                    |
|:----------------|:------------------------------------------------|
| docs            | Add documentation files for your plugin here. Users will be able to read it by running `octopress docs`. [read more]({% doc_url plugin-documentation %}) |
| fonts           | `wingdings.ttf` is copied to `_site/fonts/[plugin_slug]/wingdings.ttf`.                                 |
| images          | `cat.gif` is copied to `_site/images/[plugin_slug]/cat.gif`.                                            |
| javascripts     | `boom.js` is combined with all plugin javascripts into a single fingerprinted file.                     |
| stylesheets     | `theme.scss` and `print.css` are combined with all plugin stylesheets into a single fingerprinted file. |
| includes        | Includes are available to users by {% raw %}`{% include [plugin_slug]:some_file.html %}`{% endraw %}.   |
| layouts         | Users can add layouts by setting `layout: [plugin_slug]:some_layout` in a page's YAML front-matter.     |
| pages           | `pages/feed.xml` is processed and copied to `_site/feed.xml` at build time. Setting `permalink: feed/` renders to `_site/feed/index.xml`. |
| files           | `files/favicon.ico` is copied to `_site/favicon.ico`.                                                   |


