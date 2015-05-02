module Octopress
  module Ink
    module Commands
      class New
        def self.process_command(p)
          p.command(:new) do |c|
            c.syntax "new <PLUGIN_NAME> [options]"
            c.description "Create a new Octopress Ink plugin with Ruby gem scaffolding."
            c.option "theme", "--theme", "Create a new theme."
            c.option "path", "--path PATH", "Create a plugin at a specified path (defaults to current directory)."

            c.action do |args, options|
              if args.empty?
                raise "Please provide a plugin name, e.g. my_awesome_plugin."
              else
                @options = options
                @options['name'] = args[0]
                new_plugin
              end
            end
          end
        end

        def self.new_plugin
          path = @options['path'] ||= Dir.pwd
          gem_name = @options['name']
          path_to_gem = File.join(path, gem_name)

          if !File.exist?(path)
            raise "Directory not found: #{File.expand_path(path)}."
          end

          Dir.chdir(path) do
            if Dir.exist?(gem_name) && !Dir["#{gem_name}/*"].empty?
              raise "Directory not empty: #{File.expand_path(gem_name)}."
            end

            name = gem_name.gsub(/-/,'_')
            create_gem(name)

            fix_name(gem_name) if name != gem_name

            @settings = gem_settings(gem_name)
            @settings[:type] = @options['theme'] ? 'theme' : 'plugin'

            fix_spec_files
            add_to_gitignore
            add_dependency
            add_plugin
            add_assets
          end
        end

        def self.fix_name(path)
          name = @options['name'].gsub(/-/,'_')
          path = rename('./', name)

          rename(path, "lib/#{name}")

          gemspec = rename(path, "#{name}.gemspec")
          gem_file = rename(path, "lib/#{name}.rb")

          rewrite_name(gemspec, name)
          rewrite_name(gem_file, name)
          rewrite_name(File.join(path, 'README.md'), name)
          rewrite_name(File.join(path, 'Gemfile'), name)

          action = "rename".rjust(12).green.bold
          puts "#{action}  #{name} to #{@options['name']}"
        end

        def self.rewrite_name(path, name)
          new_name = name.gsub(/_/, '-')
          content = File.read(path).gsub(name, new_name)

          File.open(path, 'w+') do |f|
            f.write(content)
          end
        end

        def self.rename(path, target)
          old = File.join(path, target)
          new = File.join(path, target.gsub(/_/, '-'))
          FileUtils.mv(old, new)
          new
        end

        def self.fix_spec_files
          @settings[:gemspec].sub! /(#{@settings[:spec_var]}\.files\s+=\s+)(.+)$/ do
            $1+"`git ls-files -z`.split(\"\\x0\").grep(%r{^(bin/|lib/|assets/|changelog|readme|license)}i)"
          end.sub!(/\s*#{@settings[:spec_var]}\.test_files.+$/, '') 
        end

        def self.add_to_gitignore
          path = File.join @settings[:path], '.gitignore'
          content = File.open(path).read << <<-HERE
.*-cache
_site
          HERE

          File.open(path, 'w+') do |f|
            f.write(content)
          end
        end

        # Create a new gem with Bundle's gem command
        #
        def self.create_gem(name)
          begin
            require 'bundler'
            require 'bundler/cli'
            Bundler::CLI.start(['gem', name])

          rescue LoadError
            raise "To use this feature you'll need to install the bundler gem with `gem install bundler`."
          end

        end

        # Add Octopress Ink dependency to Gemspec
        #
        def self.add_dependency
          pos = @settings[:gemspec].rindex("end")
          @settings[:gemspec] = insert_before(@settings[:gemspec], pos, indent(dependencies))

          File.open(@settings[:gemspec_path], 'w+') {|f| f.write(@settings[:gemspec]) }
        end

        # Returns lines which need to be added as a dependency
        #
        # spec_var - variable used to assign gemspec attributes,
        # e.g. "spec" as in spec.name = "gem name"
        #
        def self.dependencies
          minor_version = VERSION.scan(/\d+\.\d/)[0]
          current_patch_version = VERSION.sub(/\.(alpha|rc).*/i, '')
          d  = "#{@settings[:spec_var]}.add_development_dependency \"octopress\"\n\n"
          d  = "#{@settings[:spec_var]}.add_development_dependency \"clash\"\n\n"
          d += "#{@settings[:spec_var]}.add_runtime_dependency \"octopress-ink\", \"~> #{minor_version}\"\n"
        end

        # Add Octopress Ink plugin to core module file
        #
        def self.add_plugin
          # Grab the module directory from the version.rb require.
          # If a gem is created with dashes e.g. "some-gem", Bundler puts the module file at lib/some/gem.rb
          file = File.join(@settings[:path], @settings[:module_path])
          mod = File.open(file).read
          mod = add_simple_plugin mod

          File.open(file, 'w+') {|f| f.write(mod) }
        end

        def self.add_assets
          dirs = %w{docs images fonts pages templates files layouts includes stylesheets javascripts}.map do |asset|
            File.join(@settings[:path], 'assets', asset)
          end
          create_empty_dirs dirs

          # Add Jekyll configuration file
          #
          FileUtils.touch File.join(@settings[:path], 'assets', 'config.yml')
        end

        # New plugin uses a simple configuration hash
        #
        def self.add_simple_plugin(mod)
          mod  = "#{@settings[:require_version]}\n"
          mod += "require 'octopress-ink'\n"
          if @settings[:type] == 'theme'
            mod += "\nOctopress::Ink.add_theme({\n#{indent(plugin_config)}\n})\n"
          else
            mod += "\nOctopress::Ink.add_plugin({\n#{indent(plugin_config)}\n})\n"
          end
        end


        # Return an Ink Plugin configuration hash desinged for this gem
        #
        def self.plugin_config
          depth = @settings[:module_path].count('/')
          assets_path = ("../" * depth) + 'assets'

          config = <<-HERE
name:          "#{@settings[:module_name]}",
slug:          "#{@settings[:type] == 'theme' ? 'theme' : @settings[:name]}",
gem:           "#{@settings[:name]}",
path:          File.expand_path(File.join(File.dirname(__FILE__), "..")),
version:       #{@settings[:version]},
description:   "",                                # What does your theme/plugin do?
source_url:    "https://github.com/user/project", # <- Update info
website:       ""                                 # Optional project website
          HERE
          config.rstrip
        end

        def self.write(path, contents)
          action = File.exist?(path) ? "written".rjust(12).blue.bold : "create".rjust(12).green.bold

          File.open(path, 'w+') do |f| 
            f.write(contents)
          end
          puts "#{action}  #{path.sub("#{Dir.pwd}/", '')}"
        end

        def self.create_empty_dirs(dirs)
          dirs.each do |d|
            dir = File.join(d)
            action = Dir.exist?(dir) ? "exists".rjust(12).blue.bold : "create".rjust(12).green.bold
            FileUtils.mkdir_p dir
            puts "#{action}  #{dir.sub("#{Dir.pwd}/", '')}/"
          end
        end

        # Read gem settings from the gemspec
        #
        def self.gem_settings(gem_path)
          gemspec_path = Dir.glob(File.join(gem_path, "/*.gemspec")).first

          if gemspec_path.nil?
            raise "No gemspec file found at #{gem_path}/. To create a new plugin use `octopress ink new <PLUGIN_NAME>`"
          end

          gemspec = File.open(gemspec_path).read
          require_version = gemspec.scan(/require.+version.+$/)[0]
          module_subpath = require_version.scan(/['"](.+)\/version/).flatten[0]
          version = gemspec.scan(/version.+=\s+(.+)$/).flatten[0]
          module_name = format_name(version.split('::')[-2])

          {
            path: gem_path,
            gemspec: gemspec,
            gemspec_path: gemspec_path,
            spec_var: gemspec.scan(/(\w+)\.name/).flatten[0],
            name: gemspec.scan(/name.+['"](.+)['"]/).flatten[0],
            version: version,
            require_version: require_version,
            module_path: File.join('lib', module_subpath + '.rb'),
            module_name: module_name
          }
        end

        # Add spaces between capital letters
        #
        def self.format_name(name)
          name.scan(/.*?[a-z](?=[A-Z]|$)/).join(' ')
        end

        # Indent each line of a string
        #
        def self.indent(input, level=1)
          input.gsub(/^/, '  ' * level)
        end

        # Insert a string before a position
        #
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
