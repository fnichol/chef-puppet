source :rubygems

gem 'rake'
gem 'foodcritic', :platforms => :ruby_19

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf'
end
gem 'test-kitchen'
gem 'kitchen-vagrant'
