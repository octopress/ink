module Octopress
  module Ink
    class Plugin

      def add_template_pages
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
        add_post_indexes(config, lang, 'index')
        add_post_indexes(config, lang, 'archive')
        add_meta_indexes(config, lang, 'category', 'categories')
        add_meta_indexes(config, lang, 'tag', 'tags')
      end

      def add_post_indexes(config, lang, type)
        if template = self.send(":post_#{type}")
          permalink = File.join(lang || '', config['permalinks']["post-#{type}"])

          add_template_page(template, {
            'lang' => lang,
            'permalink' => permalink
          })
        end
      end

      def add_post_feeds(config, lang)
        [main_feed, articles_feed, links_feed].compact.each do |template|

          permalink = File.join(lang || '', config['permalinks'][File.basename(template.filename, '.*')])
          add_template_page(template, {
            'lang' => lang,
            'permalink' => permalink
          })
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

      def add_meta_indexes(config, lang, type, types)
        collection = Array(config[types])

        collection ||= if lang
          Octopres::Multilingual.send(":#{types}_by_language")(lang).keys
        else
          Octopress.site.send(":#{types}").keys
        end

        collection.each do |item|
          item = item.downcase

          if template = self.send(":#{type}_index")
            permalink = File.join(lang || '', config['permalinks']["#{type}-index"].sub(":#{type}", item))

            add_template_page(template, {
              'lang' => lang,
              'permalink' => permalink
            })
          end

          if template = self.send(":#{type}_feed")
            permalink = File.join(lang || '', config['permalinks']["#{type}-feed"].sub(":#{type}", item))

            add_template_page(category_feed, {
              'lang' => lang,
              "#{type}" => item,
              'permalink' => permalink
            })
          end
        end
      end

      def post_index
        templates.find { |t| t.filename == 'post-index.html' }
      end

      def post_archive
        templates.find { |t| t.filename == 'post-archive.html' }
      end

      def category_index
        templates.find { |t| t.filename == 'category-index.html' }
      end

      def tag_index
        templates.find { |t| t.filename == 'tag-index.html' }
      end

      def main_feed
        templates.find { |t| t.filename == 'main-feed.xml' }
      end

      def articles_feed
        if defined? Octopress::Linkblog
          templates.find { |t| t.filename == 'articles-feed.xml' }
        end
      end

      def links_feed
        if defined? Octopress::Linkblog
          templates.find { |t| t.filename == 'links-feed.xml' }
        end
      end

      def category_feed
        templates.find { |t| t.filename == 'category-feed.xml' }
      end

      def tag_feed
        templates.find { |t| t.filename == 'tag-feed.xml' }
      end


      def read_config
        auto_config(super)
      end

      def auto_config(config)
        optional_configs.each do |opt_config|
          config = Jekyll::Utils.deep_merge_hashes(opt_config, config)
        end

        config
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
Yaml.load <<-CONFIG
titles:
  post-index: Posts - :site_name

permalinks:
  post-index: /
CONFIG
      end

      def post_archive_config
Yaml.load <<-CONFIG
titles:
  post-archive: Archive - :site_name

permalinks:
  posts-archive: /archive/
CONFIG
      end

      def category_index_config
Yaml.load <<-CONFIG
titles:
  category-index: Posts in :category - :site_name

permalinks:
  category-index: /categories/:category/

categories: []
CONFIG
      end

      def tag_index_config
Yaml.load <<-CONFIG
titles:
  tag-index: Posts tagged with :tag - :site_name

permalinks:
  tag-index: /tags/:tag/
  tag-feed:  /feed/tags/:tag

tags: []
CONFIG
      end

      def main_feed_config
Yaml.load <<-CONFIG
titles:
  main-feed: Posts - :site_name

permalinks:
  main-feed: /feed/
CONFIG
      end

      def links_feed_config
Yaml.load <<-CONFIG
titles:
  links-feed: Links - :site_name

permalinks:
  links-feed: /feed/links/
CONFIG
      end

      def articles_feed_config
Yaml.load <<-CONFIG
titles:
  articles-feed: Articles - :site_name

permalinks:
  articles-feed: /feed/articles/
CONFIG
      end

      def category_feed_config
Yaml.load <<-CONFIG
titles:
  category-feed: Posts in :category - :site_name

permalinks:
  category-feed: /feed/categories/:category/

categories: []
CONFIG
      end

      def tag_feed_config
Yaml.load <<-CONFIG
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
