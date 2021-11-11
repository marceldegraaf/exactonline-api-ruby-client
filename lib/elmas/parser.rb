# frozen_string_literal: true

module Elmas
  class Parser
    attr_accessor :parsed_json

    def initialize(json)
      @parsed_json = JSON.parse(json)
    rescue JSON::ParserError => e
      Elmas.error "There was an error parsing the response: #{e.class}: #{e.message}"
      Elmas.error "Contents of response: #{json.inspect}"

      @parsed_json = ""
      @error_message = ""
    end

    def results
      result["results"] if result && result["results"]
    end

    def metadata
      result["__metadata"] if result && result["__metadata"]
    end

    def result
      parsed_json["d"]
    end

    def next_page_url
      result && result["__next"]
    end

    def error_message
      @error_message ||= begin
        parsed_json["error"]["message"]["value"] if parsed_json["error"]
      end
    end

    def first_result
      results[0]
    end
  end
end
