module Octopress
  module Ink
    module Commands
      class Init
        def self.process_command(p)
          p.command(:init) do |c|
            c.syntax "init <PATH> [options]"
            c.description "Add Octopress Ink scaffolding to an existing gem based plugin."

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
          gem_dir = @options['path']
          gemspec_file = Dir.glob(File.join(gem_dir, "/*.gemspec")).first

          if gemspec_file.nil?
            raise "No gemspec file found at #{gem_dir}/. To create a new plugin use `octopress ink new <PLUGIN_NAME>`"
          end

          gemspec = File.open(gemspec_file).read
          gem_name = gemspec.scan(/name.+['"](.+)['"]/).flatten.first

          New.add_asset_dirs gem_dir
          New.add_demo_files gem_dir, gem_name

          puts "\nTo finish setting up your Octopress Ink plugin, add the following plugin template to your gem:\n\n"
          template = <<-HERE
require "octopress-ink"

# Make changes as necessary
Octopress::Ink.add_plugin({
  name:          "My plugin",
  slug:          "my-plugin",
  assets_path:   File.expand_path(File.join(File.dirname(__FILE__), '../assets')),
  type:          "plugin",
  version:       MyPlugin::VERSION,
  description:   "",
  website:       ""
})
          HERE

          puts template.yellow
        end
      end
    end
  end
end
