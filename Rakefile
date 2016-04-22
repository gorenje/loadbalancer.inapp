# -*- coding: utf-8 -*-
ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require 'fileutils'

if File.exists?(".env")
  require 'dotenv'
  Dotenv.load
end

Dir[File.join(File.dirname(__FILE__), 'lib', 'task','*.rake')].
  each { |f| load f }

task :environment do
  require_relative 'application.rb'
end

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
