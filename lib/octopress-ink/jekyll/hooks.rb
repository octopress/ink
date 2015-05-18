module Octopress
  module Ink
    if defined?(Jekyll::Hooks)

      Jekyll::Hooks.register :site, :after_reset do |site|
        Ink.watch_assets(site)
        if Plugins.registered
          Plugins.reset
        end
      end

      Jekyll::Hooks.register :site, :post_read do |site|
        Octopress.site = site
        Ink::Plugins.register
        Ink::Plugins.add_files
      end

      Jekyll::Hooks.register :site, :pre_render do |site, payload|
        Ink.payload.each do |key, val|
          payload[key] = val
        end
      end

      Jekyll::Hooks.register :site, :post_write do |site|
        Octopress::Ink::Plugins.static_files.each do |f| 
          f.write(site.dest)
        end

        Octopress::Ink::Cache.write
        Octopress::Ink::Cache.clean
      end
    else
      class SiteHook < Hooks::Site
        def reset(site)
          Ink.watch_assets(site)
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

          Octopress::Ink::Cache.write
          Octopress::Ink::Cache.clean
        end
      end
    end
  end
end

