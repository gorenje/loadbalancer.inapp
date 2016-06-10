# encoding: UTF-8
require_relative '../test_helper'

class HelpersTest < Minitest::Test

  class HelperClass
    attr_reader :content_type

    include EccrineTracking::Helpers

    def content_type(val = nil)
      !val.nil? ? @content_type = val : @content_type
    end
  end

  def setup
    @helper = HelperClass.new
  end

  context "basics" do
    should "have working if_blank" do
      assert_equal "fubar", @helper.if_blank(nil, "fubar")
      assert_equal "fubar", @helper.if_blank("", "fubar")
      assert_equal false, @helper.if_blank(false, "fubar")
      assert_equal "snafu", @helper.if_blank("snafu", "fubar")
    end

    should "return a pixel" do
      assert_pixel_data(@helper.return_one_by_one_pixel)
      assert_equal "image/gif", @helper.content_type
    end
  end
end
