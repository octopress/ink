module Octopress
  module Ink
    module Bootstrap
      attr_reader :post_index, :post_archive, :category_index, :tag_index, :main_feed, :category_feed, :tag_feed, :articles_feed, :links_feed

      # This module gives Plugins the ability to easily offer
      # Index pages, archives, RSS feeds, Category and Tag indexes
      # All with multilingual support.
      #
      def self.permalinks
        @permalinks
      end

      def self.permalink(type, item, lang)
        if Octopress.multilingual?
          @permalinks[type][item][lang]
        else
          @permalinks[type][item]
        end
      end

      def self.add_permalink(type, item, lang, permalink)
        if Octopress.multilingual?
          @permalinks[type][item] ||= {}
          @permalinks[type][item][lang] = permalink
        else
          @permalinks[type][item] = permalink
        end
      end

      # Generate site pages from bootstrappable pages and templates
      #
      def bootstrap_plugin
        reset_bootstrap
        inject_configs

        # Add pages for other languages
        if Octopress.multilingual?
          Octopress::Multilingual.languages.each { |lang| inject_pages(lang) }
        else
          inject_pages
        end
      end

      def reset_bootstrap
        @permalinks = {
          'category' => {},
          'tag' => {}
        }

        # Find pages and templates

        @post_index       = pages.find     { |p| p.filename == 'post-index.html' }
        @post_archive     = pages.find     { |p| p.filename == 'post-archive.html' }
        @main_feed        = pages.find     { |p| p.filename == 'main-feed.xml' }
        @articles_feed    = pages.find     { |p| p.filename == 'articles-feed.xml' }
        @links_feed       = pages.find     { |p| p.filename == 'links-feed.xml' }
        @category_index   = templates.find { |t| t.filename == 'category-index.html' }
        @tag_index        = templates.find { |t| t.filename == 'tag-index.html' }
        @category_feed    = templates.find { |t| t.filename == 'category-feed.xml' }
        @tag_feed         = templates.find { |t| t.filename == 'tag-feed.xml' }
      end

      # Merge optional configurations with plugin configuration
      # Plugin configs overrides optional configs
      #
      def inject_configs
        optional_configs.each do |opt_config|
          @config = Jekyll::Utils.deep_merge_hashes(YAML.load(opt_config), @config)
        end
      end
      
      # Add default configurations based on matching pages and templates
      #
      def optional_configs
        opt_config = []
        opt_config << post_index_config      if post_index
        opt_config << post_archive_config    if post_archive
        opt_config << category_index_config  if category_index
        opt_config << tag_index_config       if tag_index
        opt_config << main_feed_config       if main_feed
        opt_config << links_feed_config      if links_feed
        opt_config << articles_feed_config   if articles_feed
        opt_config << category_feed_config   if category_feed
        opt_config << tag_feed_config        if tag_feed

        # Add shared configurations for tags and categories
        #
        #opt_config << category_config_defaults
        #opt_config << tag_config_defaults

        # Add feed defaults if plugin has any feed pages
        #
        if main_feed || links_feed || articles_feed || category_feed || tag_feed
          opt_config << feed_config_defaults
        end

        opt_config
      end

      # Automatically clone pages or generate templates
      #
      # This will only occur if:
      #   - Site configuration warrants it
      #   - Plugin assets are present
      #
      # For example:
      #   - Index pages are cloned only for additonal languages on multilingual sites
      #   - Link-blogging feeds are only generated if the octopress-linkblog plugin is present
      #   - Category and tag indexes and feeds depend on post metadata and configuration
      #
      def inject_pages(lang=nil)
        config = self.config(lang)

        # Only clone these pages for additional languages
        #
        if Octopress.multilingual? && Octopress.site.config['lang'] != lang
          add_indexes(config, lang, post_index)
          add_indexes(config, lang, post_archive)
          add_feeds(config, lang, main_feed)
          add_feeds(config, lang, links_feed)
          add_feeds(config, lang, articles_feed)
        end

        add_meta_indexes(config, lang, 'category', 'categories')
        add_meta_indexes(config, lang, 'tag', 'tags')
      end

      def add_indexes(config, lang, page)
        @pages << clone_page(page, lang) if page
      end

      def add_feeds(config, lang, page)
        if page && new_page = add_post_indexes(config, lang, page)
          new_page.data['feed_type'] = feed_type(page)
        end
      end

      # Generates tag or category index or feed pages for each category and language
      # Unless configuration lists specific categories
      #
      def add_meta_indexes(config, lang, type, types)

        # Get page/feed template for category or tag
        page_template = self.send("#{type}_index")
        feed_template = self.send("#{type}_feed")

        # Don't continue if this plugin doesn't have templates for this
        return unless page_template || feed_template

        collection = if lang
          Octopress::Multilingual.send("#{types}_by_language")[lang].keys
        else
          Octopress.site.send("#{types}").keys
        end

        # User configured categories or tags
        configured = Array(config[types])

        # If configuration specifices tags or categories, only generate indexes for those
        if !configured.empty?
          collection.delete_if? { |i| !configured.inlcude?(i) }
        end

        collection.each do |item|
          item = item.downcase

          if page_template
            permalink = lang_permalink lang, config['permalinks']["#{type}-index"].sub(":#{type}", item)
            title = config['titles']["#{type}-index"].sub(":#{type}", item.capitalize).sub(":site_name", Octopress.site.config['name'])

            # Store generated permalinks for easy access by liquid tags
            Bootstrap.add_permalink(type, item, lang, permalink)

            add_template_page(page_template, {
              'lang'      => lang,
              'title'     => title,
              "#{type}"   => item,
              'permalink' => permalink,
              'plugin'    => self
            })
          end

          if feed_template
            permalink = lang_permalink lang, config['permalinks']["#{type}-feed"].sub(":#{type}", item)
            title = config['titles']["#{type}-feed"].sub(":#{type}", item.capitalize).sub(":site_name", Octopress.site.config['name'])

            add_template_page(feed_template, {
              'lang'      => lang,
              'title'     => title,
              "#{type}"   => item,
              'feed_type' => type,
              'permalink' => permalink,
              'plugin'    => self
            })
          end
        end
      end

      # Creates a copy of an Ink Page asset
      # configuring lang and permalink accordingly
      #
      def clone_page(page, lang)
        new_page = page.clone({
          'lang'      => lang,
          'permalink' => page_permalink(lang, page.permalink)
        })

        new_page.permalink_name = nil
        new_page
      end

      # Pages are only cloned for multilingual sites
      # Ensure they have language in their permalinks
      #
      def page_permalink(lang, permalink)
        if permalink.include?(":lang")
          permalink.sub(":lang", lang)
        else
          File.join("/#{lang}", permalink)
        end
      end

      # Ensure language is set in permalink if language is defined
      #
      def lang_permalink(lang, permalink)
        if lang
          permalink.sub(":lang", lang)
        else
          permalink.sub("/:lang/", '/')
        end
      end

      
      # Discern feed type based on filename
      #
      def feed_type(page)
        if page.filename =~ /articles/
          'articles'
        elsif page.filename =~ /links/
          'links'
        elsif page.filename =~ /category/
          'category'
        elsif page.filename =~ /tag/
          'tag'
        else
          'main'
        end
      end


      # Default configuration settings
      # Plugin authors can use or override these settings
      #
      def post_index_config
<<-CONFIG
titles:
  post-index: Posts - :site_name

permalinks:
  post-index: /
CONFIG
      end

      def post_archive_config
<<-CONFIG
titles:
  post-archive: Archive - :site_name

permalinks:
  posts-archive: /archive/
CONFIG
      end

      def category_index_config
<<-CONFIG
titles:
  category-index: Posts in :category - :site_name

permalinks:
  category-index: #{"/:lang" if Octopress.multilingual?}/categories/:category/
CONFIG
      end

      def tag_index_config
<<-CONFIG
titles:
  tag-index: Posts tagged with :tag - :site_name

permalinks:
  tag-index: #{"/:lang" if Octopress.multilingual?}/tags/:tag/
CONFIG
      end

      def main_feed_config
<<-CONFIG
titles:
  main-feed: Posts - :site_name

permalinks:
  main-feed: #{"/:lang" if Octopress.multilingual?}/feed/
CONFIG
      end

      def links_feed_config
<<-CONFIG
titles:
  links-feed: Links - :site_name

permalinks:
  links-feed: #{"/:lang" if Octopress.multilingual?}/feed/links/
CONFIG
      end

      def articles_feed_config
<<-CONFIG
titles:
  articles-feed: Articles - :site_name

permalinks:
  articles-feed: #{"/:lang" if Octopress.multilingual?}/feed/articles/
CONFIG
      end

      def category_feed_config
<<-CONFIG
titles:
  category-feed: Posts in :category - :site_name

permalinks:
  category-feed: #{"/:lang" if Octopress.multilingual?}/feed/categories/:category/
CONFIG
      end

      def tag_feed_config
<<-CONFIG
titles:
  tag-feed: Posts tagged with :tag - :site_name

permalinks:
  tag-feed: #{"/:lang" if Octopress.multilingual?}/feed/tags/:tag/
CONFIG
      end

      def category_config_defaults
<<-CONFIG
#{"category_indexes: false" if category_index }
#{"category_feeds: false" if category_feed }
#{"categories: []" if category_index || category_feed }
CONFIG
      end

      def tag_config_defaults
<<-CONFIG
#{"tag_indexes: false" if tag_index }
#{"tag_feeds: false" if tag_feed }
#{"tags: []" if tag_index || tag_feed }
CONFIG
      end

      def feed_config_defaults
<<-CONFIG
feed_count: 20         # Number of items in feeds
feed_excerpts: false   # Use post excerpts in feeds
#{"posts_link_out: true" if link_feed }
CONFIG
      end
    end
  end
end
