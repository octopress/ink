module Octopress
  module Ink
    module Assets
      class Sass < Stylesheet
        attr_accessor :exists, :render

        def initialize(plugin, base, file)
          @plugin = plugin
          @base = base
          @file = file
          @media = media || 'all'
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, base)
          @exists = {}
          file_check
        end

        def add
          unless File.basename(file).start_with?('_')
            Plugins.add_css_tag tag
            Plugins.static_files << StaticFileContent.new(content, destination)
          end
        end

        def ext
          File.extname(path)
        end

        def load_paths
          lp = [theme_load_path]
          lp.unshift user_load_path if Dir.exists? user_load_path
          lp
        end

        def disabled?
          is_disabled('sass', filename) || is_disabled('stylesheets', filename)
        end

        def content
          @render ||= begin
            contents = super
            if payload
              Liquid::Template.parse(contents).render!({ 'plugin' => @plugin.config }.merge(payload))
            else
              contents
            end
          end

          PluginAssetPipeline.compile_sass(self)
        end

        def destination
          File.join(base, plugin.slug, output_file_name)
        end

        private

        def user_load_path
          File.join(Plugins.custom_dir, dir, File.dirname(file)).sub /\/\.$/, ''
        end

        def theme_load_path
          File.expand_path(File.join(root, base))
        end

        def user_path
          # Allow Sass overrides to use either syntax
          if file =~ /s[ac]ss$/
            [File.join(user_dir, file), File.join(user_dir, alt_syntax_file)]
          else
            File.join user_dir, file
          end
        end

        def alt_syntax_file
          ext = File.extname(file)
          alt_ext = (ext == '.scss' ? '.sass' : '.scss')
          file.sub(ext, alt_ext)
        end

        def output_file_name
          File.basename(file.sub('@','-'), '.*') << '.css'
        end
      end
    end
  end
end

