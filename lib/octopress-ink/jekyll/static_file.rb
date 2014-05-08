module Octopress
  module Ink
    class StaticFile
      def initialize(source, dest)
        @source = source
        @dest = dest
      end

      def destination(dest)
        File.join(dest, @dest)
      end

      def relative_path
        @relative_path ||= path.sub(/\A#{Plugins.site.source}/, '')
      end

      def path
        @source
      end

      def write(dest)
        dest_path = destination(dest)

        FileUtils.mkdir_p(File.dirname(dest_path))
        FileUtils.cp(@source, dest_path)

        true
      end

      def to_liquid
        {
          "path"          => path,
          "modified_time" => Time.now.to_s,
          "extname"       => ''
        }
      end
    end
  end
end

