# frozen_string_literal: true

module Elmas
  class BadRequestException < StandardError
    def initialize(response, parsed)
      @response = response
      @parsed = parsed
      super(message)
    end

    def message
      if @parsed.error_message.present?
        "code #{@response.status}: #{@parsed.error_message}"
      else
        @response.inspect
      end
    end
  end

  class UnauthorizedException < StandardError; end

  class MinutelyRateLimitExceededException < StandardError; end
  class DailyRateLimitExceededException < StandardError; end
end
