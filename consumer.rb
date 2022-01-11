require "amqp"

class Counter
  def initialize()
    @count = 0
  end

  def plus()
    @count += 1
  end

  def print()
    50000000.times { }
    puts @count
  end
end

EventMachine.run do
  connection = AMQP.connect(:host => "127.0.0.1",
                            :user => ENV["RABBITMQ_USER"],
                            :pass => ENV["RABBITMQ_PASS"],
                            :vhost => ENV["RABBITMQ_VHOST"])
  puts "Connecting to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."
  c = Counter.new

  ch = AMQP::Channel.new(connection)
  q = ch.queue(ENV["RABBITMQ_QUEUE"], :auto_delete => false)

  q.subscribe(:block => false) do |metadata, payload|
    puts "\nReceived a message: #{payload}"
    c.plus
    c.print
  end
end
