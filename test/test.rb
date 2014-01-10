require 'colorator'

has_failed   = false
config       = File.read("_config.yml")
disabled     = "#{config}minify_html: false"
minify       = "#{config}env: production"
override_off = "#{config}env: production\nminify_html: false"
override_on  = "#{config}env: development\nminify_html: true"

def test(file)
  if diff = diff_file(file)
    puts "Failed #{file}".red
    puts diff
    has_failed = true
  else
    puts "Passed #{file}".green
  end
end

def build
  `rm -rf site && bundle exec jekyll build --trace`
end

def diff_file(file)
  diff = `diff expected/#{file} site/#{file}`
  if diff.size > 0 && File.exist?("site/#{file}")
    diff
  else
    false
  end
end

build

tags = %w{content_for footer head include include_plugin include_theme include_theme_override scripts}
tags.each { |tag| test("tag_tests/#{tag}.html") }

layouts = %w{local plugin_layout theme theme_override}
layouts.each { |tag| test("layout_tests/#{tag}.html") }

abort if has_failed

