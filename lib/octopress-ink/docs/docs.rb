module Octopress
  module Docs
    attr_reader :pages
    @pages = []

    autoload :Doc, 'octopress-ink/docs/doc'

    def self.add_plugin_doc(plugin, base_dir, file)
      add_doc_page(plugin_options(plugin).merge({
        base_dir: File.join(plugin.assets_path, base_dir),
        file: file
      }))
    end

    def self.plugin_options(plugin)
      {
        plugin_name: plugin.name,
        plugin_slug: plugin.slug,
        plugin_type: plugin.type,
        base_path: plugin.docs_base_path,
      }
    end

    def self.add_simple_docs(options)
      simple_pages = []
      %w{readme changelog}.each {|f|
        if file = select_first(options[:base_dir], f)
          simple_pages << add_doc_page(options.merge({file: file}))
        end
      }
      simple_pages
    end

    def self.add_doc_page(options)
      page = Docs::Doc.new(options)
      @pages << page
      page
    end

    def self.select_first(dir, match)
      Dir.new(dir).select { |f| f =~/#{match}/i}.first
    end

  end
end
