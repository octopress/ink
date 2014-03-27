---
title: "Create an Octopress Ink Plugin"
permalink: /guides/creating-a-plugin/
---

*This guide assumes you have already installed Git, and Ruby 1.9.3 or greater.*

Octopress Ink plugins are distributed as ruby gems so you'll probably need to create an acconut at [RubyGems.org](https://rubygems.org/sign_up) if you haven't yet. Also, be sure to install the [bundler](http://bundler.io) gem.

## Creating a Plugin

To create a new plugin from scratch run:

```sh
octopress ink new cool_plugin
```

This will add scaffolding for a gem-based plugin in the `cool_plugin` directory. To create a theme, add the `--theme` flag.  Here's what that will look like.

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
  cool_plugin/
    version.rb
  cool_plugin.rb
cool_plugin.gemspec
Gemfile
LICENSE.txt
Rakefile
README.md
```

This is basically Bundler's gem scaffolding with a few additions.

- Empty asset directories are added.
- The gemspec requires `octopress-ink` as a runtime dependency.
- A basic Octopress Ink plugin is added to `lib/cool_plugin.rb`.

