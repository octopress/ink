require 'octopress-ink'
class ThemePlugin < Octopress::Ink::Plugin
  def add_template_pages
    add_template_page('template-test.html',  {
      'title'     => 'Awesome!',
      'permalink' => '/template-test/index.html'
    })
    add_template_page('template-override-test.html', {
      'title'     => 'Crash Override',
      'permalink' => '/template-test/override.html'
    })
  end
end

Octopress::Ink::Plugins.register_plugin(ThemePlugin, {
  name:        "Classic Theme",
  type:        "theme",
  description: "Test theme y'all",
  path:         File.expand_path(File.dirname(__FILE__)),
  bootstrap: true
})
