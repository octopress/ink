require 'octopress-ink'

class AwesomeSauce < Octopress::Ink::Plugin
  def add_template_pages
    add_template_page('template-test.html', '/kittens/index.html', {'title'=>'Awesome!'})
  end
end

Octopress::Ink::Plugins.register_plugin(AwesomeSauce, {
  name:        'Awesome Sauce',
  slug:        'awesome-sauce',
  path:         File.expand_path(File.dirname(__FILE__)),
  description: "Test some plugins y'all"
})
