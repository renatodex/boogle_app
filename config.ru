require 'rubygems'
require 'bundler'

Bundler.require

["lib/**/*.rb", "models/**/*.rb"].each do |d|
  Dir[File.join(File.dirname(__FILE__), d)].each {|file| require file }
end
require './boogle'

run BoogleApp
