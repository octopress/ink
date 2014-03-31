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
          @gem_dir = @options['path']
          @gemspec_path = Dir.glob(File.join(@gem_dir, "/*.gemspec")).first

          if @gemspec_path.nil?
            raise "No gemspec file found at #{@gem_dir}/. To create a new plugin use `octopress ink new <PLUGIN_NAME>`"
          end

          New.read_gem_settings
          gemspec = File.open(@gemspec_path).read
          gem_name = gemspec.scan(/name.+['"](.+)['"]/).flatten.first

          New.add_asset_dirs
          New.add_demo_files

          puts "\nTo finish setting up your Octopress Ink plugin, add the following plugin template to your gem:\n\n"
          template = <<-HERE
require "octopress-ink"

# Make changes as necessary
Octopress::Ink.add_plugin({
#{New.plugin_config}
})
          HERE

          puts template.yellow
        end
      end
    end
  end
end
