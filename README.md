# Rate Limit

Quick and dirty rate limiter for testing backing off strings.

Adds a `X-THROTTLED-UNTIL` header with a 30 second limit.

## Starting

Use docker, it's easiest:

```sh
docker run --rm -p 3000:3000 --name rate-limit exegeteio/rate-limit
```

Make requests on port 3000.

## Stopping

```sh
docker kill rate-limit
```
