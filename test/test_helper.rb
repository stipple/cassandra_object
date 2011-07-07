require 'rubygems'
require 'bundler'
ENV['CASSANDRA_REQUIRED'] = 'true'

Bundler.setup

require 'cassandra_object'
CassandraObject::Base.establish_connection "CassandraObject"

require 'test/unit'
require 'active_support/test_case'
require 'shoulda'

require 'fixture_models'
require 'pp'

require 'test_case'