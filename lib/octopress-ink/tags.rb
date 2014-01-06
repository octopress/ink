module Octopress
  module Tags
    autoload :EmbedTag,             'octopress-ink/tags/embed'
    autoload :JavascriptTag,        'octopress-ink/tags/javascript'
    autoload :StylesheetTag,        'octopress-ink/tags/stylesheet'
    autoload :ContentForBlock,      'octopress-ink/tags/content_for'
    autoload :HeadBlock,            'octopress-ink/tags/head'
    autoload :FooterBlock,          'octopress-ink/tags/footer'
    autoload :YieldTag,             'octopress-ink/tags/yield'
    autoload :ScriptsBlock,         'octopress-ink/tags/scripts'
    autoload :WrapYieldBlock,       'octopress-ink/tags/wrap_yield'
  end
end

