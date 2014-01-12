# The Sass assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  class SassPlugin < Octopress::Plugin
    def add_files(site)
      files = local_sass_files(site)
      files = [files] unless files.is_a? Array
      files.each do |file|
        # accept ['file', 'media_type']
        if file.is_a? Array
          add_sass file.first, file.last
        # accept 'file'
        else
          add_sass file
        end
      end
      remove_jekyll_assets(@sass, site)
    end
    
    def local_sass_files(site)
      if site.config['octopress'] && site.config['octopress']['sass'] && site.config['octopress']['sass']['files']
        site.config['octopress']['sass']['files'] || []
      else
        files = Dir.glob(File.join(site.source, 'stylesheets', '**/*.s[ca]ss')).reject { |f| File.basename(f) =~ /^_/ }
        files.map { |f| f.split('stylesheets/').last}
      end
    end
  end
end

