module Octopress
  module Tags
    autoload :EmbedTag,             'octopress-plugins/tags/embed'
    autoload :JavascriptTag,        'octopress-plugins/tags/javascript'
    autoload :StylesheetTag,        'octopress-plugins/tags/stylesheet'
    autoload :ContentForBlock,      'octopress-plugins/tags/content_for'
    autoload :HeadBlock,            'octopress-plugins/tags/head'
    autoload :FooterBlock,          'octopress-plugins/tags/footer'
    autoload :YieldTag,             'octopress-plugins/tags/yield'
    autoload :ScriptsBlock,         'octopress-plugins/tags/scripts'
    autoload :WrapYieldBlock,       'octopress-plugins/tags/wrap_yield'
  end
end

