if ENV['CASSANDRA_REQUIRED']
  config = File.expand_path(File.join(File.dirname(__FILE__), 'config'))
  cassandra_bin = File.join(File.dirname(__FILE__),'..','vendor', 'cassandra-0.7','bin','cassandra')

  $pid = fork {
    exec "#{cassandra_bin} -f"
  }
  # Wait for cassandra to boot
  sleep 3
end

puts "Connecting..."
CassandraObject::Base.establish_connection "CassandraObject"

if defined?($pid)
  at_exit do
    puts "Shutting down Cassandra..."
    Process.kill('INT', $pid)
    Process.wait($pid)
  end
end
