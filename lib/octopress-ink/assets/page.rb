# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Ink
    module Assets
      class PageAsset < Asset

        def initialize(plugin, base, file)
          @root = plugin.assets_path
          @plugin = plugin
          @base = base
          @filename = file
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

        def filename
          @filename
        end

        def url_info
          "output: #{page.url.sub(/^\//,'')}"
        end

        def page
          @page ||= Page.new(Plugins.site, plugin_dir, page_dir, @file, @plugin.config)
        end

        # Add page to Jekyll pages if no other page has a conflicting destination
        #
        def copy
          return unless page.url
          Plugins.site.pages << page unless Helpers::Path.find_page(page)
        end

      end
    end
  end
end

