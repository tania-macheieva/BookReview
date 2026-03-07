class Rack::Attack
  throttle("req/ip", limit: 60, period: 1.minute) do |req|
    req.ip
  end

  throttle('req/user', limit: 100, period: 1.minute) do |req|
    req.env['current_user_id']
  end

  throttle("login/ip", limit: 5, period: 20.seconds) do |req|
    req.path == "/auth/login" ? req.ip : nil
  end

  self.throttled_response = lambda do |env|
    [429, { "Content-Type" => "application/json" }, [{ error: "Rate limit exceeded. Try again later." }.to_json]]
  end
end