---
title: "Creating a Gem"
permalink: /guides/creating-a-gem/
---

*This guide assumes you have already installed Git, and Ruby 1.9.3 or greater.*

Octopress Ink plugins are distributed as ruby gems so you'll probably need to create an acconut at [RubyGems.org](https://rubygems.org/sign_up) if you haven't yet. Also, be sure you have [bundler](http://bundler.io) installed.

### How to Create a Gem

The [bundler gem](http://bundler.io/) is a great way to manage gems and provides some terrific utilites for gem creators. Go ahead and
install it if you haven't yet.

```sh
gem install bundler
```

Now we'll use Bundler to create a gem project for our new plugin.

```sh
bundle gem baconnaise
```

That's right, this plugin will be called `baconnaise`. That command will generate a bunch of files into the new `baconnaise` directory. Take a peek inside and you'll see somethig like this:

```
lib/
  baconnaise/
    version.rb
  baconnaise.rb
baconnaise.gemspec
Gemfile
LICENSE.txt
Rakefile
README.md
```

First, you'll want to edit your `baconnaise.gemspec` to be sure the information in that is right. Be sure to change the default description and summary. The gem won't build if you have a *TODO* in either of those. Here's what we're gonig to go with.

```ruby
spec.description   = %q{Baconnaise, because mistakes have never been this spreadable.}
spec.summary       = %q{Baconnaise, because #YOLO.}
```

Next you'll want to add Octopress Ink as a runtime dependency. Here's what that looks like.

```ruby
spec.add_runtime_dependency 'octopress-ink', '~> 1.0'
```

#### A note on Version Numbering

By default the `bundle gem` command starts you off at version `0.0.1`. If you take a look at `lib/baconnaise/version.rb` you'll see this.

```
module Baconnaise
  VERSION = "0.0.1"
end
```

I'd encourage you to change your version number to `1.0.0` as soon as you release your plugin for production use. For a sensible guide on version numbers, refer to [semver.org](http://semver.org/).

---

For the next part we'll take a look at creating an Octopress Ink plugin.

[Creating a Plugin &rarr;]({% doc_url /guides/creating-a-plugin/ %})

