module Octopress
  class Page < Jekyll::Page

    # Override the destination for a page
    #
    # url - Path relative to destination directory.
    #       examples: 
    #         - '/' for the _site/index.html page
    #         - '/archive/' for the _site/archive/index.html page
    #
    def initialize(site, base, dir, name, config)
      @plugin_config = config
      super(site, base, dir, name)
    end


    # Allow pages to read url from plugin configuration
    #
    def url
      @url ||= if path_config = self.data['url_config']
        begin
          config = @plugin_config
          path_config.split('.').each { |key| config = config[key] }
          config
        rescue; end
      else
        super
      end
    end
  end
end
