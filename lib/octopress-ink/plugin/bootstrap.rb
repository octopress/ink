module Octopress
  module Ink
    module Bootstrap
      attr_reader :post_index, :post_archive, :category_index, :tag_index, :main_feed, :category_feed, :tag_feed, :articles_feed, :links_feed

      # This module gives Plugins the ability to easily offer
      # Index pages, archives, RSS feeds, Category and Tag indexes
      # All with multilingual support.
      #

      def self.reset
        @pages      = {}
        @categories = {}
        @tags       = {}
        @feeds      = {}
      end

      def self.pages
        @pages
      end

      def self.categories
        @categories
      end

      def self.tags
        @tags
      end

      def self.feeds
        @feeds
      end

      def self.page(lang, type, key)
        @pages[type][key]
      end

      def self.category(category, lang)
        category << "_#{page.lang}" if Octopress.multilingual? && page.lang 
        @categories[category]
      end

      def self.tag(category, lang)
        tag << "_#{page.lang}" if Octopress.multilingual? && page.lang 
        @tags[tag]
      end

      def self.add_page(page, key)
        if @pages[page.url].nil?
          @pages[page.url] = page

          url = page.url.sub(/index.(xml|html)/, '')

          if key == 'feeds'
            @feeds[url] = page.data['title']
          elsif key == 'tag'
            tag = page.data[key]
            tag << "_#{page.lang}" if Octopress.multilingual? && page.lang 
            @tags[tag] = url
          elsif key == 'category'
            category = page.data[key]
            category << "_#{page.lang}" if Octopress.multilingual? && page.lang 
            @categories[category] = url
          end
        end
      end

      # Generate site pages from bootstrappable pages and templates
      #
      def bootstrap_plugin
        reset_bootstrap
        inject_configs
        add_page_titles

        # Add pages for other languages
        if Octopress.multilingual?
          Octopress::Multilingual.languages.each { |lang| inject_pages(lang) }
        else
          inject_pages
        end
      end

      def reset_bootstrap
        Bootstrap.reset

        # Find pages and templates

        @post_index       = pages.find     { |p| p.filename == 'post_index.html' }
        @post_archive     = pages.find     { |p| p.filename == 'post_archive.html' }
        @main_feed        = templates.find { |p| p.filename == 'main_feed.xml' }
        @articles_feed    = templates.find { |p| p.filename == 'articles_feed.xml' }
        @links_feed       = templates.find { |p| p.filename == 'links_feed.xml' }
        @category_index   = templates.find { |t| t.filename == 'category_index.html' }
        @tag_index        = templates.find { |t| t.filename == 'tag_index.html' }
        @category_feed    = templates.find { |t| t.filename == 'category_feed.xml' }
        @tag_feed         = templates.find { |t| t.filename == 'tag_feed.xml' }
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
        opt_config << main_feed_config       if main_feed
        opt_config << links_feed_config      if links_feed
        opt_config << articles_feed_config   if articles_feed
        opt_config << category_index_config  if category_index
        opt_config << tag_index_config       if tag_index
        opt_config << category_feed_config   if category_feed
        opt_config << tag_feed_config        if tag_feed

        # Add shared configurations for tags and categories
        #
        opt_config << category_config_defaults if category_index || category_feed
        opt_config << tag_config_defaults      if tag_index || tag_feed

        # Add feed defaults if plugin has any feed pages
        #
        if main_feed || links_feed || articles_feed || category_feed || tag_feed
          opt_config << feed_config_defaults
        end

        opt_config
      end

      def add_page_titles
        [post_index, post_archive].compact.each do |page|
          page.data['title'] ||= page_title(page, config)
        end
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
        end

        add_feeds(config, lang, main_feed)

        if defined? Octopress::Linkblog
          add_feeds(config, lang, links_feed)
          add_feeds(config, lang, articles_feed)
        end

        add_meta_indexes(config, lang, 'category', 'categories')
        add_meta_indexes(config, lang, 'tag', 'tags')
      end

      def add_indexes(config, lang, page)
        @pages << clone_page(page, lang) if page
      end

      def add_feeds(config, lang, feed_template)
        if feed_template
          type = feed_type(feed_template)
          if page = add_template_page(feed_template, {
              'lang'      => lang,
              'feed_type' => type,
              'permalink' => lang_permalink(lang, config['permalinks']["#{type}_feed"]),
              'plugin'    => self
            })

            page.data['title'] = feed_title(page, config)

            Bootstrap.add_page(page, "feeds")
          end
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
        configured = Array(config[types]).map(&:downcase)

        # If configuration specifices tags or categories, only generate indexes for those
        if !configured.empty?
          collection.delete_if { |i| !configured.include?(i) }
        end

        collection.each do |item|
          item = item.downcase

          # Only add pages if plugin has a feed template for this item
          # and it hasn't been disabled in the configuration
          #
          if page_template && config["#{type}_indexes"] != false
            permalink = lang_permalink(lang, config['permalinks']["#{type}_index"]).sub(":#{type}", item)

            page = add_template_page(page_template, {
              'lang'      => lang,
              "#{type}"   => item,
              'permalink' => permalink,
              'plugin'    => self
            })

            page.data['title'] = page_title(page, config)
            Bootstrap.add_page(page, type)
          end

          # Only add feeds if plugin has a feed template for this item
          # and it hasn't been disabled in the configuration
          #
          if feed_template && config["#{type}_feeds"] != false
            permalink = lang_permalink(lang, config['permalinks']["#{type}_feed"]).sub(":#{type}", item)

            page = add_template_page(feed_template, {
              'lang'      => lang,
              "#{type}"   => item,
              'feed_type' => type,
              'permalink' => permalink,
              'plugin'    => self
            })

            page.data['title'] = feed_title(page, config)
            Bootstrap.add_page(page, 'feeds')
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
        if page.path    =~ /articles/
          'articles'
        elsif page.path =~ /links/
          'links'
        elsif page.path =~ /category/
          'category'
        elsif page.path =~ /tag/
          'tag'
        else
          'main'
        end
      end

      def page_type(page)
        if page.path.include? 'post_index'
          "post_index"
        elsif page.path.include? 'post_archive'
          "post_archive"
        elsif page.path.include? 'category_index'
          "category_index"
        elsif page.path.include? 'tag_index'
          "tag_index"
        end
      end

      def generic_title(type, config, lang=nil)
        title = config['titles'][type]
        title = title.sub(':site_name', Octopress.site.config['name'])
        title = title.sub(':lang_name', Octopress::Multilingual.language_name(lang)) if lang && Octopress.multilingual?
        title
      end

      def page_title(page, config)
        type = page_type(page)
        title = generic_title(type, config, page.lang)

        if type.match(/(category|tag)/)
          type.sub!('_index', '')
          label = tag_or_category_label(page, type, config)
          title.sub!(":#{type}", label)
        end

        title
      end

      def feed_title(page, config)
        type = feed_type(page)

        title = generic_title("#{type}_feed", config, page.lang)

        if type == 'category' || type == 'tag'
          label = page.data[type].capitalize

          if labels = Octopress.site.config["#{type}_labels"]
            label = labels[type] || label
          end

          title.sub!(":#{type}", label)
        end

        title
      end

      def tag_or_category_label(page, type, config)
        label = page.data[type].capitalize

        if labels = config["#{type}_labels"]
          label = labels[type] || label
        end

        label
      end


      # Default configuration settings
      # Plugin authors can use or override these settings
      #
      def post_index_config
<<-CONFIG
titles:
  post_index: Posts - :site_name

permalinks:
  post_index: /
CONFIG
      end

      def post_archive_config
<<-CONFIG
titles:
  post_archive: Archive - :site_name

permalinks:
  posts_archive: /archive/
CONFIG
      end

      def category_index_config
<<-CONFIG
titles:
  category_index: Posts in :category - :site_name

permalinks:
  category_index: #{"/:lang" if Octopress.multilingual?}/categories/:category/
CONFIG
      end

      def tag_index_config
<<-CONFIG
titles:
  tag_index: Posts tagged with :tag - :site_name

permalinks:
  tag_index: #{"/:lang" if Octopress.multilingual?}/tags/:tag/
CONFIG
      end

      def main_feed_config
<<-CONFIG
titles:
  main_feed: Posts - :site_name #{"(:lang_name)" if Octopress.multilingual?}

permalinks:
  main_feed: #{"/:lang" if Octopress.multilingual?}/feed/
CONFIG
      end

      def links_feed_config
<<-CONFIG
titles:
  links_feed: Links - :site_name #{"(:lang_name)" if Octopress.multilingual?}

permalinks:
  links_feed: #{"/:lang" if Octopress.multilingual?}/feed/links/
CONFIG
      end

      def articles_feed_config
<<-CONFIG
titles:
  articles_feed: Articles - :site_name #{"(:lang_name)" if Octopress.multilingual?}

permalinks:
  articles_feed: #{"/:lang" if Octopress.multilingual?}/feed/articles/
CONFIG
      end

      def category_feed_config
<<-CONFIG
titles:
  category_feed: Posts in :category - :site_name #{"(:lang_name)" if Octopress.multilingual?}

permalinks:
  category_feed: #{"/:lang" if Octopress.multilingual?}/feed/categories/:category/
CONFIG
      end

      def tag_feed_config
<<-CONFIG
titles:
  tag_feed: Posts tagged with :tag - :site_name #{"(:lang_name)" if Octopress.multilingual?}

permalinks:
  tag_feed: #{"/:lang" if Octopress.multilingual?}/feed/tags/:tag/
CONFIG
      end

      def category_config_defaults
<<-CONFIG
#{"category_indexes: false" if category_index }
#{"category_feeds: false" if category_feed }
categories: []
CONFIG
      end

      def tag_config_defaults
<<-CONFIG
#{"tag_indexes: false" if tag_index }
#{"tag_feeds: false" if tag_feed }
tags: []
CONFIG
      end

      def feed_config_defaults
<<-CONFIG
feed_count: 20         # Number of items in feeds
feed_excerpts: false   # Use post excerpts in feeds
#{"posts_link_out: true" if links_feed }
CONFIG
      end
    end
  end
end
