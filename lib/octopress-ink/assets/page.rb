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
          dir == '.' ? '' : dir
        end

        def plugin_path
          File.join(plugin_dir, dir, file)
        end

        def filename
          @filename
        end

        def url_info
          "output: #{page.url.sub(/^\//,'')}"
        end

        def user_dir
          File.join Plugins.site.source, Plugins.custom_dir, plugin.slug, base
        end

        def page
          @page ||= Page.new(Plugins.site, source_dir, page_dir, file, plugin.config)
        end

        # Add page to Jekyll pages if no other page has a conflicting destination
        #
        def add
          return unless page.url
          Plugins.site.pages << page unless Helpers::Path.find_page(page)
        end
      end
    end
  end
end

