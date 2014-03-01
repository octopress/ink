class Ink < Octopress::Ink::Plugin

  def initialize(name, type)
    @assets_path = File.dirname(File.expand_path(File.join(__FILE__,'../../../assets')))
    @version = Octopress::Ink::VERSION
    @description = "Octopress Ink is a plugin framework for Jekyll"
    @website = "http://octopress.org/ink"
    super
  end

  def docs_base_path
    'ink'
  end
end

