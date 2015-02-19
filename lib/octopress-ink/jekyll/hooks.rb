module Octopress
  module Ink
    class SiteHook < Hooks::Site

      def reset(site)
        if Plugins.registered
          Plugins.reset
        end
      end

      def post_read(site)
        Octopress.site = site
        Ink::Plugins.register
        Ink::Plugins.add_files
      end

      def merge_payload(payload, site)
        Ink.payload
      end

      def post_write(site)
        Octopress::Ink::Plugins.static_files.each do |f| 
          f.write(site.dest)
        end

        Octopress::Ink::Cache.clean
      end
    end
  end
end

