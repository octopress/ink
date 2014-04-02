module Octopress
  module Ink
    module Commands
      class Init
        def self.process_command(p)
          p.command(:init) do |c|
            c.syntax "init <PATH> [options]"
            c.description "Add Octopress Ink scaffolding to an existing gem based plugin."
            c.option "theme", "--theme", "Plugin will be a theme."

            c.action do |args, options|
              if args.empty?
                raise "Please provide a plugin name, e.g. my_awesome_plugin."
              else
                @options = options
                @options['path'] = args[0]
                init_plugin
              end
            end
          end
        end

        def self.init_plugin
          settings = New.gem_settings(@options['path'])
          settings[:type] = @options['theme'] ? 'theme' : 'plugin'

          New.add_asset_dirs(settings)
          New.add_demo_files(settings)

          puts "\nTo finish setting up your Octopress Ink plugin:\n".bold
          puts "1. Add gem requirements to your gemspec:\n\n"
          puts New.dependencies(settings).sub("\n\n", "\n").yellow
          puts "2. Add an Octopress Ink plugin to your gem, making changes as necessary:\n\n"

          template = <<-HERE
require "octopress-ink"

Octopress::Ink.add_plugin({
#{New.indent(New.plugin_config(settings))}
})
          HERE

          puts template.yellow
        end
      end
    end
  end
end
