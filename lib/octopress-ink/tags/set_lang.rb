# A placeholder for smooth integration of Octopress Multilingual
unless defined? Octopress::Multilingual
  Liquid::Template.register_tag('set_lang', Liquid::Block)
end
