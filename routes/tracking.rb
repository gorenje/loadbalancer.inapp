get '/favicon.ico' do
  return_one_by_one_pixel
end

get '/apple-*.png' do
  return_one_by_one_pixel
end

get '/robots.txt' do
  "User-agent: *\nDisallow: /\n"
end

get '*' do
  RedisQueue.new($redis_pool).
    push("%s %i %s %s %s %s" % [request.ip || '0.0.0.0',
                                Time.now.to_i,
                                request.host.split(".").first,
                                request.path,
                                if_blank(request.query_string, "p"),
                                request.user_agent])
  return_one_by_one_pixel
end
