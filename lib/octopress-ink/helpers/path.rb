module Octopress
  module Helpers
    module Path
      FILE = /(\S+)(\s?)(.*)/
      def self.parse(markup, context)
        if markup =~ FILE
          (context[$1].nil? ? $1 : context[$1]) + ' ' + ($3 || '')
        else
          markup
        end
      end

      # Allow paths to begin from the directory of the context page or
      # have absolute paths
      #
      # Input: 
      #  - file: "file.html"
      #  - context: A Jekyll context object
      #
      #  Returns the full path to a file
      #
      def self.expand(file, context)
        root = context.registers[:site].source

        # If local file, e.g. ./somefile
        if file =~ /^\.\/(.+)/
          local_dir = File.dirname context.registers[:page]['path']
          File.join root, local_dir, $1

        # If absolute or relative to a user directory, e.g. /Users/Bob/somefile or ~/somefile
        elsif file =~ /^[\/~]/
          Pathname.new(file).expand_path

        # Otherwise, assume relative to site root
        else
          File.join root, file
        end
      end
      
    end
  end
end
