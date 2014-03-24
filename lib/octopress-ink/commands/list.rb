module Octopress
  module Ink
    module Commands
      class List
        def self.process_command(p)
          p.command(:list) do |c|
            c.syntax "list [plugin] [options]"
            c.description "Get info about octopress ink plugins"
            c.option "all", "--all", "List all plugins and their assets"
            CommandHelpers.add_asset_options(c, 'List')
            c.option "docs", "--docs", "List only documentation pages"

            c.action do |args, options|
              if args.empty?
                Octopress::Ink.info(options)
              else
                name = args.first
                Octopress::Ink.plugin_info(name, options)
              end
            end
          end
        end
      end
    end
  end
end
