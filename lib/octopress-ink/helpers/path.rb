module Octopress
  module Ink
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

          # If relative path, e.g. ./somefile, ../somefile
          if file =~ /^\.+\//
            page = context['page']
            if local_dir = page['dir']
              File.expand_path(File.join(Ink.site.source, local_dir, file))
            else
              local_dir = File.dirname page['path']
              File.expand_path(File.join(root, local_dir, file))
            end

          # If absolute or relative to a user directory, e.g. /Users/Bob/somefile or ~/somefile
          elsif file =~ /^[\/~]/
            Pathname.new(file).expand_path

          # Otherwise, assume relative to site root
          else
            File.join root, file
          end
        end

        def self.site_dir
          File.expand_path(Ink.site.config['destination'])
        end

        def self.page_destination(page)
          page.destination(site_dir)
        end

        def self.find_page(page)
          find_page_by_dest page_destination(page)
        end

        def self.find_page_by_dest(dest)
          Ink.site.pages.clone.each do |p|
            return p if page_destination(p) == dest
          end
          return false
        end

        def self.remove_page(dest)
          Ink.site.pages.reject! do |p|
            page_destination(p) == dest
          end
        end
      end
    end
  end
end

