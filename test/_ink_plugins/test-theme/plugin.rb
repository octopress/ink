require 'octopress-ink'
class ThemePlugin < Octopress::Ink::Plugin
  def add_template_pages
    add_template_page('template-test.html', '/template-test/index.html', {'title'=>'Awesome!'})
    add_template_page('template-override-test.html', '/template-test/override.html', {'title'=>'Crash Override'})
  end
end

Octopress::Ink::Plugins.register_plugin(ThemePlugin, {
  name:        "Classic Theme",
  type:        "theme",
  description: "Test theme y'all",
  path:         File.expand_path(File.dirname(__FILE__)),
})
