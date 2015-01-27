module Octopress
  module Ink
    module Cache
      extend self

      INK_CACHE_DIR = '.ink-cache'
      @cache_files = []

      def read_cache(asset, options)
        path = get_cache_path(INK_CACHE_DIR, cache_label(asset), options.to_s << asset.content)
        @cache_files << path
        File.exist?(path) ? File.read(path) : nil unless path.nil?
      end

      def write_to_cache(asset, content, options)
        FileUtils.mkdir_p(INK_CACHE_DIR) unless File.directory?(INK_CACHE_DIR)
        path = get_cache_path(INK_CACHE_DIR, cache_label(asset), options.to_s << asset.content)
        File.open(path, 'w') do |f|
          f.print(content)
        end
        content
      end

      def cache_label(asset)
        "#{asset.plugin.slug}-#{File.basename(asset.file, '.*').downcase}"
      end

      def get_cache_path(dir, label, str)
        File.join(dir, "#{label}#{Digest::MD5.hexdigest(str)}.js")
      end

      def clean
        remove = Find.find(INK_CACHE_DIR).to_a.reject do |file|
          @cache_files.include?(file) || File.directory?(file)
        end

        FileUtils.rm remove
      end
    end
  end
end
