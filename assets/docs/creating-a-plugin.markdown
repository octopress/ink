---
title: "Create an Octopress Ink Plugin"
permalink: /guides/creating-a-plugin/
---

If you haven't created a Ruby gem for your plugin, check out [Creating a Gem]({% doc_url /guides/creating-a-gem/ %}).

In this section we'll create an Octopress Ink plugin. Take a look at `lib/baconnaise.rb`. You should see
something like this:

```ruby
require "baconnaise/version"

module Baconnaise
  # Your code goes here...
end
```

We'll require octopress-ink add a configuration method, and register the plugin with Octopress Ink plugin. Here's what `lib/baconnaise.rb` after we've done that.

```ruby
require "baconnaise/version"
require "octopress-ink"

module Baconnaise
  class InkPlugin < Octopress::Ink::Plugin
    def configuration
      {
        # your configuration goes here.
      }
    end
  end
end

# Register the plugin with Octopress Ink
Octopress::Ink.register_plugin(Baconnaise::InkPlugin)
```

Now when Jekyll requires your plugin, it will register with Octopress Ink. The configuration options are as follows:

{% render ./_configuration.markdown %}

For Baconnaise, our configuration medthod will look like this:

```ruby
def configuration
  {
    name:        "Baconnaise",
    slug:        "baconnaise",
    assets_path: File.expand_path(File.join(File.dirname(__FILE__), '../assets')),
    type:        "plugin",
    version:     Baconnaise::VERSION,
    description: "Baconnaise, because mistakes have never been this spreadable.",
    website:     "http://baconnaise-craze.info/or/something/"
  }
end
```
