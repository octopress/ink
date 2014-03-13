require 'octopress-ink'

class TestTheme < Octopress::Ink::Plugin
  def configuration
    {
      type:        "theme",
      description: "Test theme y'all",
      name:        "Classic Theme",
      assets_path:  File.expand_path(File.dirname(__FILE__))
    }
  end
  
  def add_assets
    add_css_files ['theme-test.css', 'theme-test2.css']
    add_css 'theme-media-test@print.css'
    add_css 'disable-this.css'
    add_sass_files ['main.scss', 'disable.sass']
  end
end

Octopress::Ink.register_plugin(TestTheme)
