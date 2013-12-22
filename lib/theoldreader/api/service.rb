require 'faraday'
require 'singleton'
require 'theoldreader/api/response'

module Theoldreader
  module API

    class Service
      include Singleton

      HOST = 'theoldreader.com'
      BASE_PATH = '/reader/api/0'
      DEFAULT_MIDDLEWARE = Proc.new do |builder|
        builder.request :url_encoded
        builder.adapter Faraday.default_adapter
      end
      FARADAY_OPTIONS = %w{request proxy ssl builder url parallel_manager params headers builder_class}.map(&:to_sym)

      attr_accessor :faraday_middleware
      # config of the http options for all requests from the client
      # http_options can be set through Service.instance.http_options[:use_ssl] = false
      attr_accessor :http_options

      def initialize
        @http_options = {}
      end

      def make_request(verb, path, params, headers, options = {})
        # use ssl by default
        options[:use_ssl] ||= true
        options[:base_path] ||= BASE_PATH
        options[:host] ||= HOST
        # per request options will override the client options
        request_options = http_options.merge(options)

        conn = Faraday.new(service_url(options[:use_ssl], options[:host], options[:base_path]),
                           faraday_options(request_options), &(faraday_middleware || DEFAULT_MIDDLEWARE))
        response = conn.send(verb, path, params, headers)
        Theoldreader::API::Response.new(response.status.to_i, response.body, response.headers)
      end

      %w{get put post delete}.each do |verb|
        define_method verb do |*args|
          make_request(verb, *args)
        end
      end

    private

      def faraday_options(options)
        Hash[ options.select { |key,value| FARADAY_OPTIONS.include?(key) } ]
      end

      def service_url(use_ssl = true, host = HOST, base_path = BASE_PATH)
        protocol = use_ssl ? 'https' : 'http'
        "#{protocol}://#{host + base_path}"
      end
    end

  end
end
