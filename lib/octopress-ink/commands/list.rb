module Octopress
  module Ink
    module Commands
      class List
        def self.process_command(p)
          p.command(:list) do |c|
            c.syntax "list [plugin] [options]"
            c.description "Get a list of installed octopress ink plugins for this site."
            c.option "all", "--all", "List all plugins and their assets."
            CommandHelpers.add_asset_options(c, 'List')

            c.action do |args, options|
              if args.empty?
                Octopress::Ink.list(options)
              else
                name = args.first
                Octopress::Ink.plugin_list(name, options)
              end
            end
          end
        end
      end
    end
  end
end
