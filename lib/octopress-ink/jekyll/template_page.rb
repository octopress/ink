module Octopress
  module Ink
    class TemplatePage < Jekyll::Page
      attr_accessor :dir, :name
      include Ink::Convertible
      
      def relative_asset_path
        site_source = Pathname.new Octopress.site.source
        page_source = Pathname.new @base
        page_source.relative_path_from(site_source).to_s
      end
    end
  end
end
