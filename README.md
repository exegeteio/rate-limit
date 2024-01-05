# Rate Limit

Quick and dirty rate limiter for testing backing off strings.

Adds a `RateLimit-Reset` header with a 30 second limit.

## Starting

Use docker, it's easiest:

```sh
docker run --rm -p 3000:3000 --name rate-limit exegete46/rate-limit
```

Make requests on port 3000.

## Config

There are two environment variables to set the rate limits:

- `RATE_LIMIT` - Number of requests.
- `RATE_PERIOD` - Timeframe for limitations in seconds.

To limit to 1000 requests per 3 seconds, you could use the following:

```sh
docker run --rm -p 3000:3000 --name rate-limit \
  -e RATE_LIMIT=1000 \
  -e RATE_PERIOD=3 \
  exegete46/rate-limit
```

## Stopping

```sh
docker kill rate-limit
```
