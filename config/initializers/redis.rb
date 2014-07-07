uri = URI.parse(ENV['REDISCLOUD_URL'] || "redis://localhost:6379/0/#{Rails.env}/cache")
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
