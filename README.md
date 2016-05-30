In App Tracking
===============

Eccrine in-app tracking server. Responsible for SSL Termination and load
balancing. This is not responsible for geoip or device detection. That
is done by the [kafkastore](https://github.com/adtekio/kafkastore).

This application has the same purpose as the
[click tracker](https://github.com/adtekio/tracking.clicks) but handles
in-app events.

It too stores its events in redis for the
[kafkastore](https://github.com/adtekio/kafkastore) to push them to kafka.

Hence the code is [extremely concise](https://github.com/adtekio/tracking.inapp/blob/448d1b81b921bf77896a467e15358bc6f022cc56/routes/tracking.rb#L10-L15).
The only thing to note here is that the subdomain determines the kafka topic
to which the event is written to. Request path determines the event type.

## Deployment

[![Deploy To Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/adtekio/tracking.inapp)

## Setup & Testing locally

To start the server:

    foreman start
