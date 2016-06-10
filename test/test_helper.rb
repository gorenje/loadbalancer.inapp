ENV['RAILS_ENV']     = 'test' # ensures that settings.environment == 'test'
ENV['RACK_ENV']      = 'test'
ENV['IP']            = 'www.example.com'
ENV['PORT']          = '9999'
ENV['TZ']            = 'UTC'

ENV['REDIS_URL_CLICKSTORE_1'] = "redis://localhost:6379/27"

require "bundler/setup"
require 'rack/test'
require 'shoulda'
require 'rr'
# use binding.pry at any point of the tests to enter the pry shell
# and pock around the current object and state
#    https://github.com/pry/pry/wiki/Runtime-invocation
require 'pry'
require 'fakeweb'
require 'minitest/autorun'

require_relative '../application.rb'

raise "Not Using Test Environment" if settings.environment != 'test'

FakeWeb.register_uri(:post, /metrics-api.librato.com/, :status => 200)

class Minitest::Test
  include RR::Adapters::TestUnit

  def _pry
    binding.pry
  end

  def assert_last_response_was_gif(msg = nil)
    assert last_response.ok?, msg
    assert_equal "image/gif", last_response.content_type, msg
    assert_pixel_data(last_response.body, msg)
  end

  def assert_pixel_data(d, msg = nil)
    assert_equal([71,73,70,56,57,97,1,0,1,0,128,1,0,0,0,0,255,255,255,33,
                  249,4,1,0,0,1,0,44,0,0,0,0,1,0,1,0,0,2,2,76,1,0,59].
                 pack("C*"), d, msg)
  end

  def assert_queue_entry(match_this, msg = nil)
    assert_equal 1, @queue.size, msg
    assert_match match_this, @queue.pop.first, msg
  end

  def silence_is_golden
    old_stderr,old_stdout,stdout,stderr =
      $stderr, $stdout, StringIO.new, StringIO.new

    $stdout = stdout
    $stderr = stderr
    result = yield
    [result, stdout.string, stderr.string]
  ensure
    $stderr, $stdout = old_stderr, old_stdout
  end

  def replace_in_env(changes)
    original_values = Hash[changes.map { |k,_| [k,ENV[k] ]}]
    changes.each { |k,v| ENV[k] = v }
    yield
  ensure
    original_values.each { |key,value| ENV[key] = value }
  end

  def add_to_env(changes)
    changes.each { |k,v| ENV[k] = v }
    yield
  ensure
    changes.keys.each { |key| ENV.delete(key) }
  end
end

class RedisQueue
  def pop(number_of_elements = 1)
    pool.execute do |redis|
      redis.pipelined do |pipe|
        number_of_elements.times { pipe.lpop(key) }
      end
    end
  end

  def size
    pool.execute {|redis| redis.llen(key)}
  end

  def clear!
    pool.execute {|redis| redis.del(key)}
  end

  def show
    pool.execute do |redis|
      redis.lrange(key, 0, 100).map do |clk|
        clk
      end
    end
  end
end
