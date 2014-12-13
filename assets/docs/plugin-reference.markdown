---
title: "Octopress Ink Plugin Reference"
permalink: /plugin-reference/
---

Octopress Ink plugins should be distributed as Ruby gems.

### Plugin Template

This is the basic template for creating an Octopress Ink plugin.

```ruby
require "octopress-ink"

Octopress::Ink.add_plugin({
  name:          "My Plugin",
  slug:          "my-plugin", # optional (derived from name if not present)
  path:          File.expand_path(File.join(File.dirname(__FILE__), "../")),
  type:          "plugin",

  # Optional (but awesome) metadata
  version:       MyPlugin::VERSION,
  description:   "My plugin does awesome stuff",
  source_url:    "https://github.com/user/project",
  website:       ""                                
})
```

### Configuration Reference

The configuration options are as follows:

| Configuration | Description |
|:--------------|:------------|
| name          | The display name for your plugin, e.g. "My Plugin" |
| path          | Path to your plugin's root directory | 
| slug          | Optional: The slug is how users will reference your plugin, (Default: sluggified name) |
| type          | Optional: "plugin" or "theme" (Default: "plugin") |
| version       | Optional: Version will be displayed with plugin info |
| description   | Optional: Description will be displayed with plugin info |
| website       | Optional: Website will be displayed with plugin info |

### Plugin Assets

You can set `assets_path` to point wherever you like insde your gem file, but in this case we have it pointing to the `assets` directiory in root of the gem. There isn't a directory there yet, so we'll need to add one, and while were at it, add any assets that this plugin will need.
