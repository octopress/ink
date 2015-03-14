require 'jekyll-watch'

# Add assets directories for selected Octopress Ink plugins to Jekyll's watch directories,
# allowing plugin authors to dynamically preview changes to their plugin's assets.
#
module Jekyll
  module Watcher
    extend self

    def build_listener(site, options)
      require 'listen'
      paths = [options['source']].concat(ink_watch_paths(site)).compact
      Listen.to(
        *paths,
        :ignore => listen_ignore_paths(options),
        :force_polling => options['force_polling'],
        &(listen_handler(site))
      )
    end

    def ink_watch_paths(site)
      if plugins = site.config['ink_watch']
        if plugins == 'all' 
          Octopress::Ink.plugins.dup.map(&:asset_paths)
        else
          plugin_paths Array(plugins)
        end
      end
    end

    def plugin_paths(plugins)
      plugins.dup.map do |plugin|
        if plugin = Octopress::Ink.plugin(plugin)
          plugin.assets_path
        end
      end.compact
    end
  end
end
