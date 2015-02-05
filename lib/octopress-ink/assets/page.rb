# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Ink
    module Assets
      class PageAsset < Asset
        attr_reader :filename
        attr_accessor :data, :permalink_name

        def initialize(plugin, base, file)
          @root = plugin.assets_path
          @plugin = plugin
          @base = base
          @filename = file
          @dir  = File.dirname(file)
          @file = File.basename(file)
          @exists = {}
          @permalink_name = File.basename(file, '.*')
          @data = {}
          file_check
        end

        # Add page to Jekyll pages if no other page has a conflicting destination
        #
        def add
          if page.url && !find_page(page)
            Octopress.site.pages << page
            plugin.config['permalinks'] ||= {}
            plugin.config['permalinks'][File.basename(filename, '.*')] ||= page.url
          end
        end

        def clone(permalink_name, permalink, data={})
          p = PageAsset.new(plugin, base, file)
          p.permalink_name = permalink_name
          p.permalink ||= permalink
          p.data.merge!(data)
          p
        end

        def find_page(page)
          site_dir = Octopress.site.dest
          dest = page.destination(site_dir)

          Octopress.site.pages.clone.each do |p|
            return p if p.destination(site_dir) == dest
          end
          return false
        end

        def page
          @page ||= begin 
            page = Page.new(Octopress.site, source_dir, page_dir, file, self)
            page.data.merge!(@data)
            page
          end
        end

        def info
          message = super
          message.sub!(/#{filename}/, permalink_name.ljust(filename.size))
          message.ljust(25) + page.permalink
        end

        def permalink
          @permalink ||= plugin.config['permalinks'][permalink_name]
        end

        def permalink=(url)
          @permalink = plugin.config['permalinks'][permalink_name] = url
        end

        private

        def page_dir
          dir == '.' ? '' : dir
        end

        def plugin_path
          File.join(plugin_dir, dir, file)
        end

        def user_dir
          File.join Plugins.custom_dir, plugin.slug, base
        end

      end
    end
  end
end
