module Octopress
  module Ink
    module Commands
      class Copy
        def self.process_command(p)
          p.command(:copy) do |c|
            c.syntax "copy <PLUGIN> [PATH] [options]"
            c.description "Copy plugin assets to PATH (PATH defaults to _plugins/[plugin_name]/)"
            c.option "all", "--all", "Copy all plugin assets"
            c.option "force", "--force", "Overwrite files"
            CommandHelpers.add_asset_options(c, 'Copy')

            c.action do |args, options|
              if args.empty?
                puts "Error: Please pass a plugin to install assets from."
                Octopress::Ink.list_plugins()
              else
                name = args[0]
                path = args[1]
                Octopress::Ink.copy_plugin_assets(name, path, options)
              end
            end
          end
        end
      end
    end
  end
end

