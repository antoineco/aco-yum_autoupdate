source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'puppetlabs_spec_helper', :require => false
# https://github.com/rspec/rspec-core/issues/1864
gem 'rspec', '< 3.2.0', {"platforms"=>["ruby_18"]}
gem 'rspec-puppet', '~> 2.1.0', :require => false

