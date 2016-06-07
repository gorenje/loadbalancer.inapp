In-App Event Tracking Endpoint
====

Application for providing an endpoint for in-app events. Events are then
passed off to redis for storage in kafka. Some other features of note:

- SSL Termination is done by the application
- Load balancing can be easily done by increasing the number of dynos
- Geoip and device detection are explicitly not done. These are subsequently
  handled by the [kafkastore](https://github.com/adtekio/kafkastore)
- Event types (determined by the [request path](https://github.com/adtekio/tracking.inapp/blob/448d1b81b921bf77896a467e15358bc6f022cc56/routes/tracking.rb#L13)) can be anything although
  some [base events](https://github.com/adtekio/analytics/blob/cd72760d899c06456163015777a6737952a52c24/lib/networks/config.rb#L3-L12) are assumed.
- Kafka topic is determined by the subdomain of the request.

This application has the same purpose as the
[click tracker](https://github.com/adtekio/tracking.clicks) but handles
in-app events. The click tracker has more logic since it also has to
handle redirects to application stores (i.e. google and apple).

### Kafka topic and event types

Hence the code is [extremely concise](https://github.com/adtekio/tracking.inapp/blob/448d1b81b921bf77896a467e15358bc6f022cc56/routes/tracking.rb#L10-L15).
The only thing to note here is that the subdomain determines the kafka topic
to which the event is written to. Request path determines the event type. The
specific event type is the string after the final '/' (slash).

This means that these two paths represent the same install
event ```/fubar/ist``` and ```/som/moe/rpa/ist```. By convention the path
is should be ```/t/ist```, i.e. with a leading ```/t```.

### Redis storage

The string that is pushed to redis is structured as follows (all values
are separeted by a single space):

```
"%s %i %s %s %s %s" % [request.ip,
                       Time.now.to_i,
                       request.host.split(".").first,
                       request.path,
                       if_blank(request.query_string, "p"),
                       request.user_agent])
```

1. Request IP which is later converted to a country by the kafkastore
   using geoip lookup.
2. Timestamp in seconds since epoch when the request was recieved by the
   tracker.
3. Kafka topic to store the message. In this case, the subdomain of the host
   of the request.
4. Event type which is represented by the request path.
5. Original query string of the request or if blank, a single 'p'.
6. User agent is appened on the end. This the later converted to device
   information by the [kafkastore](https://github.com/adtekio/kafkastore/blob/a9e3670011c71fcc669a46e62df95d06683cae79/lib/batch_worker.rb#L27). Note: the user agent
   can contain spaces, the user agent is assumed to be everything after query
   string.

If this format should change, then the [kafkastore](https://github.com/adtekio/kafkastore/blob/a9e3670011c71fcc669a46e62df95d06683cae79/lib/batch_worker.rb#L26-L42)
needs updating, along with the [click tracker](https://github.com/adtekio/tracking.clicks/blob/985520904bf22b600edf45f21626430b1ae08d60/lib/click_handler.rb#L126).

## Deployment

[![Deploy To Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/adtekio/tracking.inapp)

## Setup & Testing locally

To start the server:

    foreman start
