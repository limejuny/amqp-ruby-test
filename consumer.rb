require "amqp"

STDOUT.sync = true

class Counter
  def initialize()
    @count = 0
  end

  def pid_and_count()
    @count += 1
    50000000.times { }
    print "PID[#{Process.pid}][#{@count}]\t"
  end
end

EventMachine.run do
  connection = AMQP.connect(:host => "127.0.0.1",
                            :user => ENV["RABBITMQ_USER"],
                            :pass => ENV["RABBITMQ_PASS"],
                            :vhost => ENV["RABBITMQ_VHOST"])
  # puts "Connecting to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."
  puts "PID[#{Process.pid}]: Connecting to RabbitMQ."
  c = Counter.new

  ch = AMQP::Channel.new(connection)
  q = ch.queue(ENV["RABBITMQ_QUEUE"], :auto_delete => false)

  q.subscribe(:block => false) do |metadata, payload|
    puts "\nPID[#{Process.pid}]\tReceived a message: #{payload}"
    c.pid_and_count
    puts "100 / #{payload} = #{100 / payload.to_i}"
  end
end
