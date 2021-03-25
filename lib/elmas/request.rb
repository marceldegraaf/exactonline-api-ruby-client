# frozen_string_literal: true

module Elmas
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options = {})
      request(:get, path, options)
    end

    # Perform an HTTP POST request
    def post(path, options = {})
      request(:post, path, options)
    end

    # Perform an HTTP PUT request
    def put(path, options = {})
      request(:put, path, options)
    end

    # Perform an HTTP DELETE request
    def delete(path, options = {})
      request(:delete, path, options)
    end

    private

    def build_path(path, options)
      unless options[:use_raw_path]
        path = "#{division}/#{path}" unless options[:no_division]
        path = "#{endpoint}/#{path}" unless options[:no_endpoint]
        path = "#{options[:url] || base_url}/#{path}"
      end
      path
    end

    def add_headers(options = {})
      content_type = options[:content_type] || "application/#{response_format}"
      headers = {}
      headers["Content-Type"] = content_type
      headers["Accept"] = content_type
      headers["Authorization"] = "Bearer #{access_token}" if access_token

      if options[:custom_description_language]
        headers["CustomDescriptionLanguage"] = options[:custom_description_language]
      end

      headers
    end

    # Perform an HTTP request
    def request(method, path, options = {})
      path = build_path(path, options)

      response = connection.send(method) do |request|
        case method
        when :post, :put
          request.url path
          request.body = options[:body] || options[:params].to_json
        when :get, :delete
          request.url path
        end
        request.headers = add_headers(options)
      end
      Response.new(response)
    end
  end
end
