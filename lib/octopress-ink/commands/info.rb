module Octopress
  module Ink
    module Commands
      class Info
        def self.process_command(p)
          p.command(:info) do |c|
            c.syntax "octopress ink info [plugin] [options]"
            c.description "Get info about octopress ink plugins"
            CommandHelpers.add_asset_options(c)

            c.action do |args, options|
              if args.empty?
                Octopress::Ink.info
              else
                name = args.first
                puts Octopress::Ink.plugin_info(name, options)
              end
            end
          end
        end
      end
    end
  end
end
