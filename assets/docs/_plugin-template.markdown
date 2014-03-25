```ruby
require "octopress-ink"

module MyPlugin
  class InkPlugin < Octopress::Ink::Plugin
    
    # Define the configuration for your plugin
    #
    def configuration
      {
        name:          "My plugin",
        slug:          "my-plugin",
        assets_path:   File.expand_path(File.join(File.dirname(__FILE__), '../assets')),
        type:          "plugin",
        version:       MyPlugin::VERSION,
        description:   "",
        website:       ""
      }
    end
  end
end

# Register the plugin with Octopress Ink
Octopress::Ink.register_plugin(SomePlugin::InkPlugin)
```
