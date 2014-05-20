require 'colorator'
require 'find'
require '../lib/octopress-ink.rb'

@has_failed = false
@failures = []

def pout(str)
  print str
  $stdout.flush
end

def test(file, target_dir, source_dir="site")
  site_file = Dir.glob("#{source_dir}/#{file}").first
  if site_file && File.exist?(site_file)
    if diff_file(file, target_dir, source_dir)
      pout "F".red
      @has_failed = true
    else
      pout ".".green
    end
  else
    @failures << "File: #{source_dir}/#{file}: No such file or directory."
    @has_failed = true
    pout "F".red
  end
end

def test_missing(file, dir)
  if File.exist? File.join dir, file 
    @failures << "File #{file} should not exist".red
    pout "F".red
    @has_failed = true
  else
    pout ".".green
  end
end

def build(options={})
  config = ['_config.yml'] << options[:config]
  cmd = "rm -rf site && bundle exec jekyll build --config #{config.join(',')}"
  #cmd += " --octopress-config #{options[:octopress_config]}" if options[:octopress_config]
  if options[:octopress_config]
    FileUtils.cp options[:octopress_config], '_octopress.yml'
  end
  `#{cmd}`
  `rm _octopress.yml`
end

def diff_file(file, target_dir='expected', source_dir='site')
  diff = `diff #{target_dir}/#{file} #{source_dir}/#{file}`
  if diff.size > 0
    @failures << <<-DIFF
Failure in #{file}
---------
#{diff.gsub(/\A.+?\n/,'').gsub(/^(<.+?)$/){|m| m.red}.gsub(/>.+/){|m| m.green}}
---------
DIFF
  else
    false
  end
end

def test_tags(dir)
  tags = %w{content_for abort_false include assign capture wrap render filter}
  tags.each { |file| test("test_tags/#{file}.html", dir) }

  tags = %w{abort_true, abort_posts}
  tags.each { |file| test_missing("test_tags/#{file}.html", 'site') }
end

def test_pages(dir)
  pages = %w{plugin_page plugin_page_override theme_page three}
  pages.each { |file| test("test_pages/#{file}.html", dir) }
  test("test_pages/feed/index.xml", dir)
end

def test_post(dir)
  test("2014/02/01/test-post.html", dir)
end

def test_layouts(dir)
  layouts = %w{local plugin_layout theme theme_override}
  layouts.each { |file| test("test_layouts/#{file}.html", dir) }
end

def test_configs(dir)
  configs = %w{plugin_config theme_config}
  configs.each { |file| test("test_config/#{file}.html", dir) }
end

def test_stylesheets(dir, concat=true)
  if concat
    stylesheets = %w{all-* print-*}
    stylesheets.each { |file| test("stylesheets/#{file}.css", dir) }
  else
    plugin_stylesheets = %w{plugin-media-test plugin-test}
    plugin_stylesheets.each { |file| test("stylesheets/awesome-sauce/#{file}.css", dir) }

    theme_stylesheets = %w{theme-media-test theme-test theme-test2}
    theme_stylesheets.each { |file| test("stylesheets/theme/#{file}.css", dir) }
  end
end

def test_javascripts(dir, concat=true)
  if concat
    javascripts = %w{all-*}
    javascripts.each { |file| test("javascripts/#{file}.js", dir) }
  else
    %w{bar foo}.each { |file| test("javascripts/theme/#{file}.js", dir) }
  end
end

def test_root_assets(dir)
  root_assets = %w{favicon.ico favicon.png robots.txt}
  root_assets.each { |file| test(file, dir) }
end

def test_copy_assets(dir)
  Find.find("#{dir}/_copy") do |file|
    unless File.directory? file
      test(file.sub("#{dir}"+"/", ''), dir, 'source')
    end
  end
  `rm -rf source/_copy`
end

def test_disabled(dir)
  files = %w{
    stylesheets/theme/disable-this.css
    stylesheets/theme/disable.css
    disable-test.html
    test_pages/disable-test.html
    javascripts/disable-this.js
    fonts/font-one.otf
    fonts/font-two.ttf
  }
  files.each { |file| test_missing(file, dir) }
end

def print_failures
  puts "\n"
  if @has_failed
    @failures.each do |failure|
      puts failure
    end
    abort
  else
    puts "All passed!".green
  end
end

build

test_post('expected')
test_tags('expected')
test_pages('expected')
test_layouts('expected')
test_stylesheets('concat_css')
test_javascripts('concat_js')
test_configs('expected')
test_root_assets('expected')
test_disabled('site')

system "octopress ink copy theme --path _copy --force"
test_copy_assets('copy_test')

system "octopress ink copy theme --layouts --pages --path _copy --force"
test_copy_assets('copy_layouts_pages')

build octopress_config: '_concat_false.yml'
test_stylesheets('concat_css_false', false)
test_javascripts('concat_js_false', false)

print_failures
