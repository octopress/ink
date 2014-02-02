# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Assets
    class PageAsset < Asset

      def initialize(plugin, type, file)
        @root = plugin.assets_path
        @plugin = plugin
        @type = type
        @dir  = File.dirname(file)
        @file = File.basename(file)
        @exists = {}
        file_check
      end

      def page_dir
        @dir == '.' ? '' : @dir
      end

      def plugin_path
        File.join(plugin_dir, @dir, @file)
      end

      def dest
        File.expand_path(Plugins.site.config['destination'])
      end

      def page
        @page ||= Page.new(Plugins.site, plugin_dir, page_dir, @file, @plugin.config)
      end

      # Add page to Jekyll pages if no other page has a conflicting destination
      #
      def copy
        return unless page.url
        overriden = false
        Plugins.site.pages.clone.each do |p|
          overriden = true if p.destination(dest) == @page.destination(dest)
        end
        Plugins.site.pages << @page unless overriden
      end

    end
  end
end

