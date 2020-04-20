class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('req/ip', limit: 100, period: 5.minutes) do |req|
    req.ip
  end

  throttle('logins/ip', limit: 3, period: 20.seconds) do |req|
    if req.path == '/auth/user_token'
      req.ip
    end
  end

  throttle('signup/ip', limit: 3, period: 1.day) do |req|
    if req.path == '/auth/users' && req.post?
      req.ip
    end
  end

  throttle('update user/ip', limit: 3, period: 1.day) do |req|
    if req.path == '/auth/users' && req.put?
      req.ip
    end
  end
end
