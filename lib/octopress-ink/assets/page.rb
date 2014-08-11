# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Ink
    module Assets
      class PageAsset < Asset
        attr_reader :filename

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

        # Add page to Jekyll pages if no other page has a conflicting destination
        #
        def add
          if page.url && !Octopress.config['docs_mode']
            Octopress.site.pages << page unless find_page(page)
          end
        end

        def find_page(page)
          site_dir = Octopress.site.config['destination']
          dest = page.destination(site_dir)

          Octopress.site.pages.clone.each do |p|
            return p if p.destination(site_dir) == dest
          end
          return false
        end

        def page
          unless @page 
            @page = Page.new(Octopress.site, source_dir, page_dir, file, plugin.config)
          end
          @page
        end

        def info
          message = super
          message.ljust(25) + url_info
        end

        private

        def page_dir
          dir == '.' ? '' : dir
        end

        def plugin_path
          File.join(plugin_dir, dir, file)
        end

        def url_info
          "/#{page.url.sub(/^\//,'')}"
        end

        def user_dir
          File.join Octopress.site.source, Plugins.custom_dir, plugin.slug, base
        end

      end
    end
  end
end

