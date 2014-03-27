module Octopress
  module Ink
    module Commands
      class New
        def self.process_command(p)
          p.command(:new) do |c|
            c.syntax "new <PLUGIN_NAME> [options]"
            c.description "Create a new Octopress Ink plugin with Ruby gem scaffolding."
            c.option "path", "--path PATH", "Create a plugin at a specified path (defaults to current directory)"
            c.option "theme", "--theme", "Create a new theme"
            #c.option "force", "--force", "Overwrite files"

            c.action do |args, options|
              if args.empty?
                raise "Please provide a plugin name, e.g. my_awesome_plugin."
              else
                options['name'] = args[0]
                new_plugin options
              end
            end
          end
        end

        def self.new_plugin(options)
          path = options['path'] || Dir.pwd
          name = options['name']
          type = options['theme'] ? 'theme' : 'plugin'

          if !Dir.exist?(path)
            raise "Directory not found: #{File.expand_path(path)}."
          end

          FileUtils.cd path do
            create_gem(name)
            add_dependency
            add_plugin(type)
            add_asset_dirs
          end
        end

        def self.create_gem(name)
          puts output = `bundle gem #{name}`
          @gemspec_file = output.match(/^\s*\w+\s+(.+.gemspec)/)[1]
          @module_file = output.match(/^\s*\w+\s+(.+.rb)/)[1]
          @gem_dir = @gemspec_file.match(/(.+?)\//)[1]
        end

        # Add Octopress Ink dependency to Gemspec
        #
        def self.add_dependency
          minor_version = VERSION.scan(/\d\.\d/)[0]
          gemspec = File.open(@gemspec_file).read
          dependency = "\n  spec.add_runtime_dependency 'octopress-ink', '~> #{minor_version}', '>= #{VERSION}'\n"

          pos = gemspec.index("\n  spec.add_development_dependency")
          gemspec = insert_before(gemspec, pos, dependency)

          File.open(@gemspec_file, 'w+') {|f| f.write(gemspec) }
        end

        # Add Octopress Ink plugin to core module file
        #
        def self.add_plugin(type)
          mod = File.open(@module_file).read
          
          # Find the inner most module name
          @modules  = mod.scan(/module\s+(.+?)\n/).flatten
          @mod_path = @modules.join('::')

          pos = mod.index("\nmodule")
          mod = insert_before(mod, pos, "require \"octopress-ink\"\n")
          mod = add_plugin_class(mod, type)
          mod += "\nOctopress::Ink.register_plugin(#{@mod_path}::InkPlugin)"

          File.open(@module_file, 'w+') {|f| f.write(mod) }
        end

        def self.add_asset_dirs
          %w{images fonts pages files layouts includes stylesheets javascripts}.each do |asset|
            dir = File.join(@gem_dir, 'assets', asset)
            FileUtils.mkdir_p dir
          end
        end

        # Add plugin class definition
        #
        def self.add_plugin_class(mod, type)
          plugin_name = format_name(@modules.last)
          plugin_slug = Filters.sluggify(plugin_name)
          depth = @module_file.count('/') - 1
          assets_path = ("../" * depth) + 'assets'

          plugin = <<-HERE
class InkPlugin < Octopress::Ink::Plugin
  
  # Define the configuration for your plugin
  #
  def configuration
    {
      name:          "#{plugin_name}",
      slug:          "#{plugin_slug}",
      assets_path:   File.expand_path(File.join(File.dirname(__FILE__), "#{assets_path}")),
      type:          "#{type}",
      version:       #{@mod_path}::VERSION,
      description:   "",
      website:       ""
    }
  end
end
HERE
          # match indentation
          plugin = "\n" + plugin.gsub(/^/, '  ' * @modules.length)
          mod.sub(/\s*# Your code goes here.+/, plugin)
        end


        # Add spaces between capital letters
        #
        def self.format_name(name)
          name.scan(/.*?[a-z](?=[A-Z]|$)/).join(' ')
        end

        def self.insert_before(str, pos, input)
          if pos
            str[0..(pos - 1)] + input + str[pos..-1]
          else
            str
          end
        end
      end
    end
  end
end
