class Ink < Octopress::Ink::Plugin

  def initialize
    @name        = "Octopress Ink"
    @slug        = "ink"
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), '../../../assets'))
    @version     = Octopress::Ink::VERSION
    @description = "Octopress Ink is a plugin framework for Jekyll"
    @website     = "http://octopress.org/ink"
    super
  end

  def docs_base_path
    'docs/ink'
  end
end

