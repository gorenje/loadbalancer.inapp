# encoding: UTF-8
require_relative '../test_helper'

class TrackingTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file('config.ru').first
  end

  def setup
    @queue = RedisQueue.new($redis_pool)
    @queue.clear!
    assert_equal 0, @queue.size
  end

  context "admin stuff" do
    should "handle apple images" do
      get("/apple-fubar.png")
      assert_last_response_was_gif
      assert_equal 0, @queue.size
    end

    should "handle favicon" do
      get("/favicon.ico")
      assert_last_response_was_gif
      assert_equal 0, @queue.size
    end

    should "handle robots.txt" do
      get("/robots.txt")
      assert last_response.ok?
      assert_equal "User-agent: *\nDisallow: /\n", last_response.body
      assert_equal 0, @queue.size
    end
  end

  context "in-app tracking calls" do
    should "work with no path" do
      get("")
      assert_last_response_was_gif
      assert_queue_entry(/127\.0\.0\.1 [0-9]+ example \/ p /)
    end

    should "work with path" do
      get("/t/fubar")
      assert_last_response_was_gif
      assert_queue_entry(/127\.0\.0\.1 [0-9]+ example \/t\/fubar p /)
    end

    should "work with path & user agent" do
      get("/t/fubar", {}, { 'HTTP_USER_AGENT' => "iPhone" })
      assert_last_response_was_gif
      assert_queue_entry(/127\.0\.0\.1 [0-9]+ example \/t\/fubar p iPhone/)
    end

    should "work no path & user agent & params" do
      get("", {:fubar => :snafu}, { 'HTTP_USER_AGENT' => "iPhone" })
      assert_last_response_was_gif
      assert_queue_entry(/127\.0\.0\.1 [0-9]+ example \/ fubar=snafu iPhone/)
    end

    should "work with path & user agent & params" do
      get("/t/t", {:fubar => :snafu}, { 'HTTP_USER_AGENT' => "iPhone" })
      assert_last_response_was_gif
      assert_queue_entry(/127\.0\.0\.1 [0-9]+ example \/t\/t fubar=snafu iPhone/)
    end

    should "work nil remote ip" do
      get("/t/t", {}, {'REMOTE_ADDR' => nil, "HTTP_X_FORWARDED_FOR" => nil})
      assert_last_response_was_gif
      assert_queue_entry(/0\.0\.0\.0 [0-9]+ example \/t\/t p /)
    end
  end
end
