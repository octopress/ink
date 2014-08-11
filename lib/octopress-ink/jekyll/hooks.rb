module Octopress
  module Ink
    class SiteHook < Hooks::Site

      def post_read(site)
        Octopress.site = site
        Ink::Plugins.register
        Ink::Plugins.add_files
      end

      def merge_payload(payload, site)
        config = Ink::Plugins.config

        new_payload = {
          'plugins'   => config['plugins'],
          'theme'     => config['theme'],
          'octopress' => {
            'version' => Ink.version
          }
        }

        if Octopress.config['docs_mode']
          new_payload['doc_pages'] = Ink::Plugins.doc_pages
        end

        new_payload
      end

      def post_write(site)
        Octopress::Ink::Plugins.static_files.each do |f| 
          f.write(site.config['destination'])
        end
      end
    end
  end
end

