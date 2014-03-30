---
title: "Create an Octopress Ink Plugin"
permalink: /guides/creating-a-plugin/
---

*This guide assumes you have already installed Git, and Ruby 1.9.3 or greater.*

Octopress Ink plugins are distributed as ruby gems so you'll need to create an acconut at [RubyGems.org](https://rubygems.org/sign_up) if you haven't yet. Also, be sure to install the [bundler](http://bundler.io) gem.

## Creating a plugin

Creating an Octopress Ink plugin is very simple. Here's the standard template.

{% render ./_plugin-template.markdown %}

The configuration options are as follows.

{% render ./_configuration.markdown %}

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

Open up `lib/spicy_baconnaise.rb` and you'll see the plugin template mostly filled out for you.

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

## Adding plugin assets

Add a bunch of files to assets and you'll win.
