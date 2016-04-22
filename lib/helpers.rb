# encoding: UTF-8
module EccrineTracking
  module Helpers
    def if_blank(val,default)
      val.blank? ? default : val
    end

    def click_queue
      @click_queue ||= RedisQueue.new($redis_pool)
    end

    def return_one_by_one_pixel
      content_type "image/gif"
      [71,73,70,56,57,97,1,0,1,0,128,1,0,0,0,0,255,255,255,33,249,4,1,0,0,
       1,0,44,0,0,0,0,1,0,1,0,0,2,2,76,1,0,59].pack("C*")
    end
  end
end
