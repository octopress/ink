module Octopress
  module Ink
    module Assets
      autoload :Asset,                'octopress-ink/assets/asset'
      autoload :Config,               'octopress-ink/assets/config'
      autoload :LangConfig,           'octopress-ink/assets/lang_config'
      autoload :FileAsset,            'octopress-ink/assets/file'
      autoload :PageAsset,            'octopress-ink/assets/page'
      autoload :Template,             'octopress-ink/assets/template'
      autoload :LocalTemplate,        'octopress-ink/assets/local_template'
      autoload :Javascript,           'octopress-ink/assets/javascript'
      autoload :Coffeescript,         'octopress-ink/assets/coffeescript'
      autoload :Stylesheet,           'octopress-ink/assets/stylesheet'
      autoload :Sass,                 'octopress-ink/assets/sass'
      autoload :Include,              'octopress-ink/assets/include'
      autoload :Layout,               'octopress-ink/assets/layout'
    end
  end
end
