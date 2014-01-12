# The CSS assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  class CSSPlugin < Octopress::Plugin
    def add_files(site)
      files = local_css_files(site)
      files = [files] unless files.is_a? Array
      files.each do |file|
        # accept ['file', 'media_type']
        if file.is_a? Array
          add_stylesheet file.first, file.last
        # accept 'file'
        else
          add_stylesheet file
        end
      end
      if Plugins.concat_css(site)
        remove_jekyll_assets(@stylesheets, site)
      end
    end

    def local_css_files(site)
      files = Dir.glob(File.join(site.source, 'stylesheets', '**/*.css'))
      files.map { |f| f.split('stylesheets/').last }
    end

  end
end

