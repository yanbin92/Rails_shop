# config valid only for current version of Capistrano
#远程部署相关
lock '3.6.1'
#---
# Excerpted from "Agile Web Development with Rails 5",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails5 for more book information.
#---
# be sure to change these values
user = 'expand'
domain = '127.0.0.1'

# adjust if you are using RVM, remove if you are not
set :rvm_type, :system
set :rvm_ruby_string, 'ruby-2.3.1'

# name of your application
set :application, 'rails_shop'

# file paths
set :repo_url, "#{user}@#{domain}:git/#{fetch(:application)}.git" 
set :deploy_to, "/home/#{user}/deploy/#{fetch(:application)}" 
set :passenger_restart_with_touch, true

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain

# As Capistrano executes in a non-interactive mode and therefore doesn't cause
# any of your shell profile scripts to be run, the following might be needed
# if (for example) you have locally installed gems or applications.  Note:
# this needs to contain the full values for the variables set, not simply
# the deltas.
#
# set :default_environment, {
#   'PATH' => '<your paths>:/usr/local/bin:/usr/bin:/bin',
#   'GEM_PATH' => '<your paths>:/usr/lib/ruby/gems/1.8'
# }
#
# See https://rvm.io/deployment/capistrano#environment for more info.

