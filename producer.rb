require "amqp"

AMQP.start(:host => "127.0.0.1",
           :user => ENV["RABBITMQ_USER"],
           :pass => ENV["RABBITMQ_PASS"],
           :vhost => ENV["RABBITMQ_VHOST"]) do |connection|
  ch = AMQP::Channel.new(connection)
  q = ch.queue(ENV["RABBITMQ_QUEUE"], :auto_delete => false)
  x = ch.default_exchange

  x.publish ARGV[0], :routing_key => q.name do
    connection.close { EventMachine.stop }
  end
end
