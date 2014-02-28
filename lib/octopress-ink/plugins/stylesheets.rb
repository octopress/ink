# The CSS assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  module Ink
    class StylesheetsPlugin < Plugin

      def register_stylesheets

        add_stylesheets local_stylesheets

        remove_jekyll_assets @sass if @sass

        if Plugins.concat_css
          remove_jekyll_assets @css if @css
        end
      end

      def disabled?(*args)
        Octopress.config['stylesheets'] == false
      end

      def add_stylesheets(files)
        files = [files] unless files.is_a? Array
        files.each do |file|
          # accept ['file', 'media_type']
          if file.is_a? Array
            if file.first =~ /\.css/
              @css << Assets::LocalStylesheet.new(self, stylesheets_dir, file.first, file.last)
            else
              @sass << Assets::LocalSass.new(self, stylesheets_dir, file.first, file.last)
            end
          # accept 'file'
          else
            if file =~ /\.css/
              @css << Assets::LocalStylesheet.new(self, stylesheets_dir, file)
            else
              @sass << Assets::LocalSass.new(self, stylesheets_dir, file)
            end
          end
        end
        files
      end

      def stylesheets_dir
        Octopress.config['stylesheets_dir'] || '_stylesheets'
      end

      def local_stylesheets
        config = Octopress.config
        source = Plugins.site.source
        
        # If they manually specify files
        #
        if config['stylesheets'].is_a? Array
          config['stylesheets']
        else
          dir = File.join(source, stylesheets_dir)
          files = find_assets(dir).reject { |f| File.basename(f) =~ /^_.*?s[ac]ss/ }
          files.map { |f| f.split(dir).last }
        end
      end
    end
  end
end

