# The CSS assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  module Ink
    class StylesheetsPlugin < Octopress::Ink::Plugin
      def add_files

        add_stylesheets local_stylesheets

        remove_jekyll_assets @sass

        if Plugins.concat_css
          remove_jekyll_assets @stylesheets
        end
      end

      def add_stylesheets(files)
        files = [files] unless files.is_a? Array
        files.each do |file|
          # accept ['file', 'media_type']
          if file.is_a? Array
            if file.first =~ /\.css/
              add_stylesheet file.first, file.last
            else
              add_sass file.first, file.last
            end
          # accept 'file'
          else
            if file =~ /\.css/
              add_stylesheet file
            else
              add_sass file
            end
          end
        end
        files
      end

      def local_stylesheets
        config = Plugins.site.config
        source = Plugins.site.source
        if config['octopress'] && config['octopress']['stylesheets']
          config['octopress']['stylesheets'] || []
        else
          dir = File.join(source, 'stylesheets/')
          css = Dir.glob(File.join(dir, '**/*.css'))
          sass = Dir.glob(File.join(dir, '**/*.s[ca]ss')).reject { |f| File.basename(f) =~ /^_.*?s[ac]ss/ }
          files = css.concat sass
          files.map { |f| f.split(dir).last }
        end
      end
    end
  end
end

