module Octopress
  module Filters
    

    # Returns the site's config root or '/' if the config isn't set
    #
    def root
      root_url = Plugins.site.config['root']
      root_url.nil? ? '/' : File.join('/', root_url)
    end

    # Prepends input with a url fragment
    #
    # input - An absolute url, e.g. /images/awesome.gif
    # url   - The fragment to prepend the input, e.g. /blog
    #
    # Returns the modified url, e.g /blog
    #
    def expand_url(input, url=nil)
      url ||= root
      if input =~ /^#{url}/
        input
      else
        File.join(url, input)
      end
    end

    # Prepend all absolute urls with a url fragment
    #
    # input - The content of a page or post
    # url   - The fragment to prepend absolute urls
    #
    # Returns input with modified urls
    #
    def expand_urls(input, url=nil)
      url ||= root
      input.gsub /(\s+(href|src)\s*=\s*["|']{1})(\/[^\"'>]*)/ do
        $1 + expand_url($3, url)
      end
    end

    # Prepend all urls with the full site url
    #
    # input - The content of a page or post
    #
    # Returns input with all urls expanded to include the full site url
    # e.g. /images/awesome.gif => http://example.com/images/awesome.gif
    #
    def full_urls(input)
      url = Plugins.site.config['url']
      if url.nil?
        raise IOError.new "Could expand urls: Please add your published url to your _config.yml, eg url: http://example.com/"
      else
        File.join url, expand_urls(input)
      end
    end
    
    # Prepend a url with the full site url
    #
    # input - a url
    #
    # Returns input with all urls expanded to include the full site url
    # e.g. /images/awesome.gif => http://example.com/images/awesome.gif
    #
    def full_url(input)
      url = Plugins.site.config['url']
      if url.nil?
        raise IOError.new "Could expand urls: Please add your published url to your _config.yml, eg url: http://example.com/"
      else
        File.join url, expand_url(input)
      end
    end

    # Truncate a string at the <!--more--> marker
    # input - The content of a post or page
    #
    # Returns only the content preceeding the marker
    #
    def excerpt(input)
      if input.index(/<!--\s*more\s*-->/i)
        input.split(/<!--\s*more\s*-->/i)[0]
      else
        input
      end
    end

    # Checks for excerpt markers (helpful for template conditionals)
    #
    # input - The content of a page or post
    #
    # Returns true/false if the excerpt marker is found
    #
    def has_excerpt(input)
      input =~ /<!--\s*more\s*-->/i ? true : false
    end

    # Returns a title cased string based on John Gruber's title case http://daringfireball.net/2008/08/title_case_update
    def titlecase(input)
      input.titlecase
    end

    # Formats a string for use as a css classname, removing illegal characters
    def classify(input)
      input.gsub(/ /,'-').gsub(/[^\w-]/,'').downcase
    end

    # Replaces newlines with space characters
    def join_spaces(input)
      input.gsub(/\s+/, ' ').strip
    end

    def compact_newlines(input)
      input.gsub(/\n{2,}/, "\n").gsub(/^ +\n/,"")
    end

    module_function :root, :expand_url, :expand_urls, :full_url, :full_urls, :excerpt, :titlecase, :classify, :join_spaces, :compact_newlines
    public :expand_url, :expand_urls, :full_url, :full_urls, :excerpt, :titlecase, :classify, :join_spaces, :compact_newlines
  end
end
