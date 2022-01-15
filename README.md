# amqp-ruby-test
Rabbitmq Pub/Sub test with amqp gem

# consumer

```bash
$ docker build -t . rconsume
$ docker run --rm -it --env-file .env --network host rconsume
```
