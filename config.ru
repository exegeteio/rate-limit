require "rack"
require "rack/attack"
require "active_support/all"

RATE_LIMIT = ENV.fetch("RATE_LIMIT", 30).to_i
RATE_PERIOD = ENV.fetch("RATE_PERIOD", 30).to_i.seconds
puts "===== Throttling to #{RATE_LIMIT} requests per #{RATE_PERIOD} seconds"

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
Rack::Attack.throttled_response_retry_after_header = true

class Rack::Attack

  throttle("req/ip", limit: RATE_LIMIT, period: RATE_PERIOD) do |req|
    req.ip
  end

  self.throttled_responder = lambda do |request|
    puts "Throttled!"

    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]

    headers = {
      "RateLimit-Limit" => match_data[:limit].to_s,
      "RateLimit-Remaining" => "0",
      "RateLimit-Reset" => (now + (match_data[:period] - now % match_data[:period])).to_s
    }

    [
      429,
      headers,
      ["Throttled"]
    ]
  end
end

use Rack::Attack

count = 0
run do |_env|
  puts "Request #{count}"
  count += 1
  [200, {}, ["Hello World"]]
end
