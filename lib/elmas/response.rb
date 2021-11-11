# frozen_string_literal: true

require File.expand_path("../parser", __FILE__)
require File.expand_path("../utils", __FILE__)

module Elmas
  class Response
    attr_accessor :status_code, :response
    attr_writer :body

    def initialize(response)
      if response.respond_to?(:headers)
        puts "--- Requests remaining: #{response.headers["x-ratelimit-minutely-remaining"].inspect}"
      end

      @response = response

      raise RateLimitedException.new() if rate_limited?
      raise_and_log_error if fail?
    end

    def success?
      @response.success? || SUCCESS_CODES.include?(status)
    end

    def rate_limited?
      if @response.respond_to?(:headers)
        header = response.headers["x-ratelimit-minutely-remaining"]

        if header
          header.to_i <= 0
        else
          false
        end
      else
        false
      end
    end

    def body
      @response.body
    end

    def parsed
      Parser.new(body)
    end

    def result
      Elmas::ResultSet.new(parsed)
    end

    def results
      Elmas::ResultSet.new(parsed)
    end

    def status
      @response.status
    end

    def fail?
      ERROR_CODES.include? status
    end

    def error_message
      parsed.error_message
    end

    def log_error
      message = "An error occured, the response had status #{status}. The content of the error was: #{error_message}"
      Elmas.error(message)
    end

    SUCCESS_CODES = [
      201, 202, 203, 204, 301, 302, 303, 304
    ].freeze

    ERROR_CODES = [
      400, 401, 402, 403, 404, 429, 500, 501, 502, 503
    ].freeze

    UNAUTHORIZED_CODES = [
      400, 401, 402, 403
    ].freeze

    private

    def raise_and_log_error
      log_error
      raise BadRequestException.new(@response, parsed)
    end
  end
end
