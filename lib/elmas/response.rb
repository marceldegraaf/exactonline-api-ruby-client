# frozen_string_literal: true

require File.expand_path("../parser", __FILE__)
require File.expand_path("../utils", __FILE__)

module Elmas
  class Response
    attr_accessor :status_code, :response
    attr_writer :body

    def initialize(response)
      @response = response
      raise_and_log_error if fail?
    end

    def success?
      @response.success? || SUCCESS_CODES.include?(status)
    end

    def body
      @response.body
    end

    def parsed
      puts
      puts body.inspect
      puts
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
      400, 401, 402, 403, 404, 500, 501, 502, 503
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
