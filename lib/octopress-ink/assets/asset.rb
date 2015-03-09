module Octopress
  module Ink
    module Assets
      class Asset
        attr_reader :plugin, :dir, :base, :root, :file, :replacement
        attr_accessor :exists

        FRONT_MATTER = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

        def initialize(plugin, base, file)
          @file = file
          @base = base
          @plugin = plugin
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, base)
          @exists = {}
          file_check
        end

        def info
          "  - #{asset_info}"
        end

        def asset_info
          message = filename.ljust(35)

          if replaced?
            message += "Replaced by #{@replacement} plugin"
          elsif disabled?
            message += "Disabled by configuration"
          elsif path.to_s != plugin_path
            shortpath = File.join(Plugins.custom_dir.sub(Dir.pwd,''), dir).sub('/','')
            message += "From: #{File.join(shortpath,filename)}"
          end
          
          message
        end

        def filename
          file
        end

        def disabled?
          @disabled || is_disabled(base, filename) || replaced?
        end

        def replaced?
          !@replacement.nil?
        end

        def disable
          @disabled = true
        end

        def is_disabled(base, file)
          config = @plugin.config['disable']
          config.include?(base) || config.include?(File.join(base, filename))
        end

        def path
          @path ||= begin
            files = []
            files << user_path
            files << plugin_path
            files = files.flatten.reject { |f| !exists? f }

            if files.empty?
              raise IOError.new "Could not find #{File.basename(file)} at #{file}"
            end

            files[0]
          end
        end

        def ext
          File.extname(filename)
        end

        def read
          File.read(path)
        end

        def add
          Plugins.static_files << StaticFile.new(path, destination)
        end

        # Copy asset to user override directory
        #
        def copy(target_dir)
          return unless exists? plugin_path

          if target_dir
            target_dir = File.join(target_dir, base)
          else
            target_dir = user_dir
          end

          FileUtils.mkdir_p File.join(target_dir, File.dirname(file))
          FileUtils.cp plugin_path, File.join(target_dir, file)
          target_dir.sub!(Dir.pwd+'/', '')
          "+ ".green + "#{File.join(target_dir, filename)}"
        end

        # Remove files from Jekyll's static_files array so it doesn't end up in the
        # compiled site directory. 
        #
        def remove_jekyll_asset
          Octopress.site.static_files.clone.each do |sf|
            if sf.kind_of?(Jekyll::StaticFile) && sf.path == path.to_s
              Octopress.site.static_files.delete(sf)
            end
          end
        end

        def destination
          File.join(base, plugin.slug, file)
        end

        def content
          @content ||= begin
            if read =~ FRONT_MATTER
              $POSTMATCH
            else
              read
            end
          end
        end

        def payload
          @payload ||= begin
            p = Ink.payload
            p['jekyll'] = {
              'version' => Jekyll::VERSION,
              'environment' => Jekyll.env
            }
            p['site'] = Octopress.site.config
            p['site']['data'] = Octopress.site.site_data
            p['page'] = data

            p
          end
        end

        def data
          if read =~ FRONT_MATTER
            SafeYAML.load($1)
          else
            {}
          end
        end

        private

        def source_dir
          if exists? user_path
            user_dir
          else
            plugin_dir
          end
        end

        def plugin_dir
          File.join root, base
        end

        def plugin_path
          File.join plugin_dir, file
        end

        def user_dir
          File.join Plugins.custom_dir, dir
        end

        def local_plugin_path
          File.join Octopress.site.source, dir, file
        end

        def user_path
          File.join user_dir, filename
        end

        def file_check
          if !exists? plugin_path
            raise "\nPlugin: #{plugin.name}: Could not find #{File.basename(file)} at #{plugin_path}".red
          end
        end

        def exists?(file)
          exists[file] ||= File.exists?(file)
          exists[file]
        end
      end
    end
  end
end
