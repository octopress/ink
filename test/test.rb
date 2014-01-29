require 'colorator'
ENV['OCTOPRESS_ENV'] = 'TEST'

@has_failed = false
@failures = {}

def pout(str)
  print str
  $stdout.flush
end

def test(file, dir)
  if diff = diff_file(file, dir)
    @failures[file] = diff
    pout "F".red
    @has_failed = true
  else
    pout ".".green
  end
end

def build(config='')
  config = ['_config.yml'] << config
  `rm -rf site && bundle exec jekyll build --config #{config.join(',')}`
end

def diff_file(file, dir='expected')
  if File.exist?(Dir.glob("site/#{file}").first)
    diff = `diff #{dir}/#{file} site/#{file}`
    if diff.size > 0
      diff
    else
      false
    end
  else
    "File: site/#{file}: No such file or directory."
  end
end

build

def test_tags(dir)
  tags = %w{content_for include assign capture wrap render}
  tags.each { |file| test("test_tags/#{file}.html", dir) }
end

def test_layouts(dir)
  layouts = %w{local plugin_layout theme theme_override}
  layouts.each { |file| test("test_layouts/#{file}.html", dir) }
end

def test_configs(dir)
  configs = %w{plugin_config theme_config}
  configs.each { |file| test("test_config/#{file}.html", dir) }
end

def test_stylesheets(dir, concat_css=true)
  if concat_css
    stylesheets = %w{all-* print-*}
    stylesheets.each { |file| test("stylesheets/#{file}.css", dir) }
  else
    local_stylesheets = %w{site test}
    local_stylesheets.each { |file| test("stylesheets/#{file}.css", dir) }

    plugin_stylesheets = %w{plugin-media-test plugin-test}
    plugin_stylesheets.each { |file| test("awesome-sauce/stylesheets/#{file}.css", dir) }

    theme_stylesheets = %w{theme-media-test theme-test theme-test2}
    theme_stylesheets.each { |file| test("theme/stylesheets/#{file}.css", dir) }
  end
end

def test_root_assets(dir)
  root_assets = %w{favicon.ico favicon.png robots.txt}
  root_assets.each { |file| test(file, dir) }
end

def print_failures
  puts "\n"
  if @has_failed
    @failures.each do |name, diff|
      puts "Failure in #{name}:".red
      puts "---------"
      puts diff
      puts "---------"
    end
    abort
  else
    puts "All passed!".green
  end
end

test_tags('expected')
test_layouts('expected')
test_stylesheets('concat_css')
test_configs('expected')
test_root_assets('expected')

build '_concat_css_false.yml'
test_stylesheets('concat_css_false', false)

build '_sass_compact.yml'
test_stylesheets('sass_compact')

build '_sass_expanded.yml'
test_stylesheets('sass_expanded')

print_failures

