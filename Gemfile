# -*- ruby -*-
source 'http://rubygems.org'

ruby '2.2.3'

gem 'rake'
gem 'sinatra', "1.3.4"
gem 'sinatra-contrib'
gem 'librato-metrics'
gem 'librato-rack'

gem 'unicorn'
gem 'newrelic_rpm', "~>3.7.3"
gem 'newrelic-redis'
gem 'hiredis'
gem 'redis', :require => ["redis", "redis/connection/hiredis"]
gem 'ya_circuit_breaker', "0.0.3"

gem 'pry'
gem 'term-ansicolor'
gem 'highline'

gem 'fast_blank'
gem 'oj'
gem 'oj_mimic_json'

group :test do
  gem 'hpricot'
  gem 'rack-test'
  gem 'rr', '1.0.4'
  gem 'shoulda'
  gem 'jasmine'
  gem 'fakeweb'
end

group :development do
  gem 'thin' # so ruby application.rb works
  gem 'foreman'
  gem 'papertrail'
  gem 'erubis'
  gem 'mail'
  gem 'dotenv'
end
