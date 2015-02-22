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
          @permalink_name = file.sub(File.extname(file), '')
          @data = {}
          file_check
        end

        # Add page to Jekyll pages if no other page has a conflicting destination
        #
        def add
          if page.url && !find_page(page)
            Octopress.site.pages << page
            plugin.config['permalinks'] ||= {}
            plugin.config['permalinks'][@permalink_name] ||= page.url
          end
        end

        def clone(permalink, permalink_name=nil)
          p = PageAsset.new(plugin, base, file)
          p.permalink_name = permalink_name
          p.permalink ||= permalink
          p
        end

        def merge_data(data={})
          self.data.merge!(data)
          self
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
            page = Page.new(Octopress.site, source_dir, page_dir, file)

            if permalink
              page.data['permalink'] = permalink
            else
              permalink = page.data['permalink']
            end

            page.data.merge!(@data)
            page
          end
        end

        def info
          message = super
          name = permalink_name << page.ext
          message.sub!(/#{filename}\s*/, name.ljust(35))
          message.ljust(25) << (permalink || page.permalink || '')
        end

        def permalink
          @permalink ||= plugin.config['permalinks'][permalink_name]
        end

        def permalink=(url)
          @permalink = url
          if permalink_name
            plugin.config['permalinks'][permalink_name] = url
          end
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
