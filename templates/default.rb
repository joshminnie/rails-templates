gem "lodash-rails"
gem "view_component"
gem "dartsass-rails"

gem_group :development do
  # Linting
  gem "reek", require: false
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false

  # Documentation
  gem "redcarpet", require: false
  gem "yard", require: false
end

gem_group :development, :test do
  # Data generation
  gem "factory_bot_rails"
  gem "faker"
  gem "rb-readline"
end

gem_group :test do
  gem "rspec-rails", require: false
  gem "simplecov", require: false
  gem "webmock", require: false
  gem "shoulda-matchers", require: false
end

if yes?("Do you want to create a gemset for this app?")
  file(".ruby-version", "ruby-#{RUBY_VERSION}", force: true)
  file(".ruby-gemset", @app_name)
  run("$SHELL -l -c \"rvm use #{RUBY_VERSION}@#{@app_name} --create\"")
end

run("bundle install")
run("bundle package")

template(File.expand_path("../shared/.rubocop.yml", __dir__), ".rubocop.yml")
run("rubocop -a")
run("rubocop --auto-gen-config")

# Fix README
template(File.expand_path("../shared/README.md", __dir__), "README.md", force: true)

generate("rspec:install")

if yes?("Do you want to create a root controller?")
  name = ask("What would you like to call it?").to_s.underscore
  generate(:controller, "#{name} show --no-helper")
  route("root to: \"#{name}#show\"")
end
