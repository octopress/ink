module Octopress
  module Ink
    module Bootstrap

      def bootstrap_templates
        inject_configs

        if Octopress.multilingual?
          # Add pages for other languages

          Octopress::Multilingual.languages.each do |lang|
            inject_pages(lang)
          end
        else
          inject_pages
        end
      end

      def inject_pages(lang=nil)
        config = self.config(lang)
        add_post_indexes(config, lang, post_index)
        add_post_indexes(config, lang, post_archive)
        add_post_feeds(config, lang, main_feed)
        add_post_feeds(config, lang, links_feed)
        add_post_feeds(config, lang, articles_feed)
        #add_meta_indexes(config, lang, 'category', 'categories')
        #add_meta_indexes(config, lang, 'tag', 'tags')
      end

      def add_post_indexes(config, lang, page)
        if page && Octopress.multilingual? && Octopress.site.config['lang'] != lang
          @pages << clone_page(page, lang) if page
        end
      end

      def add_post_feeds(config, lang, page)
        if page && Octopress.multilingual? && Octopress.site.config['lang'] != lang
          if new_page = add_post_indexes(config, lang, page)
            new_page.data['feed_type'] = feed_type(page)
          end
        end
      end

      # Discern feed type based on filename
      def feed_type(page)
        if page.filename =~ /articles/
          'articles'
        elsif page.filename =~ /links/
          'links'
        elsif page.filename =~ /category/
          'category'
        else
          'main'
        end
      end

      def clone_page(page, lang)
        new_page = page.clone({
          'lang' => lang,
          'permalink' => lang_permalink(lang, page.permalink)
        })

        new_page.permalink_name = nil
        new_page
      end

      def lang_permalink(lang, permalink)
        if lang
          permalink.sub("/#{Octopress.site.config['lang']}", '')
          File.join(lang, permalink)
        else
          permalink
        end
      end

      def add_meta_indexes(config, lang, type, types)
        collection = Array(config[types])

        collection ||= if lang
          Octopres::Multilingual.send("#{types}_by_language", lang).keys
        else
          Octopress.site.send("#{types}").keys
        end

        collection.each do |item|
          item = item.downcase

          if template = self.send("#{type}_index")
            permalink = File.join(lang || '', config['permalinks']["#{type}-index"].sub(":#{type}", item))

            add_template_page(template, {
              'lang' => lang,
              'permalink' => permalink
            })
          end

          if template = self.send("#{type}_feed")
            permalink = File.join(lang || '', config['permalinks']["#{type}-feed"].sub(":#{type}", item))

            add_template_page(category_feed, {
              'lang' => lang,
              "#{type}" => item,
              'permalink' => permalink
            })
          end
        end
      end

      #def add_category_pages(config, lang)
        #categories = Array(config['categories'])

        #categories ||= if lang
          #Octopres::Multilingual.categories_by_language(lang).keys
        #else
          #Octopress.site.categories.keys
        #end

        #categories.each do |category|
          #category = category.downcase

          #if category_index
            #permalink = File.join(lang || '', config['permalinks']['category-index'].sub(':category', category))

            #add_template_page(category_index, {
              #'lang' => lang,
              #'category' => category,
              #'permalink' => permalink
            #})
          #end

          #if category_feed
            #permalink = File.join(lang || '', config['permalinks']['category-feed'].sub(':category', category))

            #add_template_page(category_feed, {
              #'lang' => lang,
              #'category' => category,
              #'permalink' => permalink
            #})
          #end
        #end
      #end
      
      def post_index
        pages.find { |p| p.filename == 'post-index.html' }
      end

      def post_archive
        pages.find { |p| p.filename == 'post-archive.html' }
      end

      def category_index
        templates.find { |t| t.filename == 'category-index.html' }
      end

      def tag_index
        templates.find { |t| t.filename == 'tag-index.html' }
      end

      def main_feed
        templates.find { |t| t.filename == 'main.xml' }
      end

      def articles_feed
        if defined? Octopress::Linkblog
          pages.find { |p| p.filename == 'articles.xml' }
        end
      end

      def links_feed
        if defined? Octopress::Linkblog
          pages.find { |p| p.filename == 'links.xml' }
        end
      end

      def category_feed
        templates.find { |t| t.filename == 'category-feed.xml' }
      end

      def tag_feed
        templates.find { |t| t.filename == 'tag-feed.xml' }
      end

      def inject_configs
        optional_configs.each do |opt_config|
          @config = Jekyll::Utils.deep_merge_hashes(YAML.load(opt_config), @config)
        end
      end

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

        opt_config
      end

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
  category-index: /categories/:category/

categories: []
CONFIG
      end

      def tag_index_config
<<-CONFIG
titles:
  tag-index: Posts tagged with :tag - :site_name

permalinks:
  tag-index: /tags/:tag/

tags: []
CONFIG
      end

      def main_feed_config
<<-CONFIG
titles:
  main-feed: Posts - :site_name

permalinks:
  main-feed: /feed/
CONFIG
      end

      def links_feed_config
<<-CONFIG
titles:
  links-feed: Links - :site_name

permalinks:
  links-feed: /feed/links/
CONFIG
      end

      def articles_feed_config
<<-CONFIG
titles:
  articles-feed: Articles - :site_name

permalinks:
  articles-feed: /feed/articles/
CONFIG
      end

      def category_feed_config
<<-CONFIG
titles:
  category-feed: Posts in :category - :site_name

permalinks:
  category-feed: /feed/categories/:category/

categories: []
CONFIG
      end

      def tag_feed_config
<<-CONFIG
titles:
  tag-feed: Posts tagged with :tag - :site_name

permalinks:
  tag-feed: /feed/tags/:tag/

categories: []
CONFIG
      end
    end
  end
end
