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

Octopress::Ink.register_theme(ThemePlugin, {
  name:        "Classic Theme",
  description: "Test theme y'all",
  path:         File.expand_path(File.dirname(__FILE__))
})
