```ruby
require "octopress-ink"

Octopress::Ink.add_plugin({
  name:          "My Plugin",
  slug:          "my-plugin",
  assets_path:   File.expand_path(File.join(File.dirname(__FILE__), '../assets')),
  type:          "plugin",
  version:       MyPlugin::VERSION,
  description:   "",
  website:       ""
})
```
