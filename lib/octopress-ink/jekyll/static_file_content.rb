module Octopress
  module Ink
    class StaticFileContent < StaticFile
      def write(dest)
        dest_path = destination(dest)

        FileUtils.mkdir_p(File.dirname(dest_path))
        File.open(dest_path, 'w') { |f| f.write(@source) }

        true
      end

      def to_liquid
        {
          "path"          => '',
          "modified_time" => Time.now.to_s,
          "extname"       => ''
        }
      end

      def relative_path
        @relative_path ||= '.'
      end
    end
  end
end

