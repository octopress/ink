require 'colorator'

`rm -rf _site; bundle exec jekyll build --trace`

diff = `diff expected.html site/test.html`

if diff.size == 0 and File.exist?('site/test.html')
  puts "passed".green
else
  puts "failed".red
  puts diff
  abort
end


require 'colorator'

has_failed   = false
config       = File.read("_config.yml")
disabled     = "#{config}minify_html: false"
minify       = "#{config}env: production"
override_off = "#{config}env: production\nminify_html: false"
override_on  = "#{config}env: development\nminify_html: true"

def test(type, version)
  build
  if diff = diff_file(type)
    puts "Failed #{type}".red
    puts diff
    has_failed = true
  else
    puts "Passed #{type}".green
  end
end

def build
  #ENV['BUNDLE_GEMFILE'] = "jekyll-#{version}/Gemfile"
  `rm -rf site && bundle exec jekyll build --trace`
end

def diff_file(file, version)
  diff = `diff expected/#{file} site/#{file}`
  if diff.size > 0 && File.exist?("site/#{file}")
    diff
  else
    false
  end
end

## Test default
puts "Testing with no configuration"
test('compressed')

#puts "Testing with env: production and minify_html: false"
#File.open("_config.yml", "w") { |f| f.write(override_on) }

# Reset original config without compression enabled
File.open("_config.yml", "w") do |f|
  f.write(config)
end

abort if has_failed

