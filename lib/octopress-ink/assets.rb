module Octopress
  module Ink
    module Assets
      autoload :Asset,                'octopress-ink/assets/asset'
      autoload :LocalAsset,           'octopress-ink/assets/local_asset'
      autoload :Config,               'octopress-ink/assets/config'
      autoload :FileAsset,            'octopress-ink/assets/file'
      autoload :PageAsset,            'octopress-ink/assets/page'
      autoload :DocPageAsset,         'octopress-ink/assets/doc_page'
      autoload :Javascript,           'octopress-ink/assets/javascript'
      autoload :Coffeescript,         'octopress-ink/assets/coffeescript'
      autoload :Stylesheet,           'octopress-ink/assets/stylesheet'
      autoload :LocalStylesheet,      'octopress-ink/assets/local_stylesheet'
      autoload :LocalCoffeescript,    'octopress-ink/assets/local_coffeescript'
      autoload :Sass,                 'octopress-ink/assets/sass'
      autoload :LocalSass,            'octopress-ink/assets/local_sass'
      autoload :Include,              'octopress-ink/assets/include'
      autoload :Layout,               'octopress-ink/assets/layout'
    end
  end
end
