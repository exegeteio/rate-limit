require 'rack'
require 'rack/attack'
require 'active_support/all'

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('req/ip', limit: 30, period: 30.seconds) do |req|
    req.ip
  end

  self.throttled_responder = lambda do |_env|
    puts 'Throttled!'
    [
      429,
      {
        'X-THROTTLED-UNTIL': "#{30.seconds.from_now.utc.to_i} Z"
      },
      ['Throttled']
    ]
  end
end

use Rack::Attack

count = 0
run do |_env|
  puts "Request #{count}"
  count += 1
  [200, {}, ['Hello World']]
end
