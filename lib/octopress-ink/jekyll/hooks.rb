module Jekyll
  module Convertible
    alias_method :do_layout_orig, :do_layout
    alias_method :read_yaml_orig, :read_yaml 

    def do_layout(payload, layouts)
      # The contentblock tags needs access to the converter to process it while rendering.
      payload = Octopress::Ink.payload(payload)
      payload['converter'] = self.converter

      do_layout_orig(payload, layouts)
    end

    def read_yaml(base, name, opts = {})
      read_yaml_orig(base, name, opts)

      if type == :post
        self.data.merge! add_post_vars(self.data)
      end


      if type == :page || type == :post
        if self.data['date'] || self.respond_to?(:date)
          the_date = self.data['date'] || self.date
          text      = format_date(the_date)
          xmlschema = datetime(the_date).xmlschema
          html      = date_html(text, xmlschema)

          self.data['date_xml']  = xmlschema
          self.data['date_html'] = html
        end
      end

      if self.data['updated']
        text      = format_date(self.data['updated'])
        xmlschema = datetime(self.data['updated']).xmlschema
        html      = date_html(text, xmlschema)

        self.data['updated_date_xml']  = xmlschema
        self.data['updated_date_html'] = html
      end
    end

    def add_post_vars(data)
      linkpost = data['external-url']

      if linkpost
        config = Octopress::Ink.config['linkpost']
      else
        config = Octopress::Ink.config['post']
      end

      if extract_excerpt.to_s.strip != content.strip
        excerpted = true
      end

      if Octopress::Ink.config['titlecase']
        Octopress::Utils.titlecase!(data['title'])
      end

      {
        'title_text' => title_text(config, data['title']),
        'title_html' => title_html(config, data['title']),
        'title_url'  => linkpost || self.url,
        'linkpost'   => !linkpost.nil?,
        'excerpted'  => excerpted
      }
    end

    def date_html(text, xmlschema)
      "<time class='entry-date' datetime='#{ xmlschema }' pubdate>#{ text }</time>"
    end

    def format_date(date)
      format = Octopress::Ink.config['date_format']
      date = datetime(date)
      if format == 'ordinal'
        ordinalize(date)
      else
        date.strftime(format)
      end
    end

    # Returns an ordidinal date eg July 22 2007 -> July 22nd 2007
    def ordinalize(date)
      date = datetime(date)
      d = "<span class='date-month'>#{date.strftime('%b')}</span> "
      d += "<span class='date-day'>#{date.strftime('%-d')}</span>"
      d += "<span class='date-suffix'>#{ordinal_suffix(date)}</span>, "
      d += "<span class='date-year'>#{date.strftime('%Y')}</span>"
    end

    # Returns an ordinal number. 13 -> 13th, 21 -> 21st etc.
    def ordinal_suffix(date)
      number = date.strftime('%e').to_i
      if (11..13).include?(number % 100)
        "th"
      else
        case number % 10
        when 1; "st"
        when 2; "nd"
        when 3; "rd"
        else    "th"
        end
      end
    end

    def datetime(input)
      case input
      when Time
        input
      when String
        Time.parse(input) rescue Time.at(input.to_i)
      when Numeric
        Time.at(input)
      else
        raise "Invalid Date:", "'#{input}' is not a valid datetime."
        exit(1)
      end
    end
    

    def title_html(config, title)
      title = Octopress::Ink::Filters.unorphan(title)

      return title if !config['marker']

      marker = "<span class='post-marker post-marker-#{config['marker_position']}'>#{config['marker']}</span>"
      position = config['marker_position']

      if config['marker_position'] == 'before'
        title = "#{marker}&nbsp;#{title}"
      else
        title = "#{title}&nbsp;#{marker}"
      end

      title
    end

    def title_text(config, title)
      return title if !config['marker']
      position = config['marker_position']

      if config['marker_position'] == 'before'
        "#{config['marker']} #{title}"
      else
        "#{title} #{config['marker']}"
      end
    end
  end

  # Create a new page class to allow partials to trigger Jekyll Page Hooks.
  class ConvertiblePage
    include Convertible
    
    attr_accessor :name, :content, :site, :ext, :output, :data
    
    def initialize(site, name, content)
      @site     = site
      @name     = name
      @ext      = File.extname(name)
      @content  = content
      @data     = { layout: "no_layout" } # hack
      
    end
    
    def render(payload)
      do_layout(payload, { no_layout: nil })
    end
  end

  class Site
    alias_method :write_orig, :write
    # Called after write
     
    def write
      write_orig
      Octopress::Ink::Plugins.static_files.each do |f| 
        f.write(config['destination'])
      end
    end
  end
end
