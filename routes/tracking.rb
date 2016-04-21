get '/' do
  handle_tracking_call
  return_one_by_one_pixel
end

get '/favicon.ico' do
  return_one_by_one_pixel
end

get '/apple-*.png' do
  return_one_by_one_pixel
end
