Gem::Specification.new do |s|
  s.name    = 'cassandra_object'
  s.version = '0.6.1'
  s.email   = ["michael@koziarski.com", "mpd@stippleit.com"]
  s.author  = ["Michael Koziarski", "Michael Dungan"]

  s.description = %q{Gives you most of the familiarity of ActiveRecord, but with the scalability of cassandra.}
  s.summary     = %q{Maps your objects into cassandra.}
  s.homepage    = %q{http://github.com/stipple/cassandra_object}

  s.add_dependency('activesupport', '~> 3.2')
  s.add_dependency('activemodel',   '~> 3.2')
  s.add_dependency('tzinfo')
  s.add_dependency('cassandra',     '~> 0.12')
  s.add_dependency('thrift_client',     '~> 0.8')
  s.add_development_dependency('shoulda')
  s.add_dependency('nokogiri')

  s.files = Dir['lib/**/*'] + Dir["vendor/**/*"]
  s.require_path = 'lib'
end
