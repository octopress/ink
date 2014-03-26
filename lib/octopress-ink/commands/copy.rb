module Octopress
  module Ink
    module Commands
      class Copy
        def self.process_command(p)
          p.command(:copy) do |c|
            c.syntax "copy <PLUGIN> [options]"
            c.description "Copy plugin assets to _plugins/PLUGIN/."
            c.option "all", "--all", "Copy all plugin assets."
            c.option "force", "--force", "Overwrite files."
            c.option "path", "--path PATH", "Copy plugin assets to an alternate path."
            CommandHelpers.add_asset_options(c, 'Copy')

            c.action do |args, options|
              if args.empty?
                puts "Error: Please pass a plugin slug to install assets from that plugin."
                Octopress::Ink.list_plugins
              else
                name = args[0]
                Octopress::Ink.copy_plugin_assets(name, options)
              end
            end
          end
        end
      end
    end
  end
end

