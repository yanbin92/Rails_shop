require 'rubygems'
require 'bundler/setup'
require './app/store'
use Rack::ShowExceptions
map '/index' do
run StoreApp.new
end
