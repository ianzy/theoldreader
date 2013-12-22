require 'theoldreader/api/service'
require 'theoldreader/errors'

module Theoldreader
  class Base

    %w{get post put delete}.each do |method|
      define_singleton_method(method) do |params = {}, options = {}|
        headers = options.delete(:headers) || {}
        url = options.delete(:endpoint) || endpoint
        response = service.send(method, url, {output: format}.merge(params),
                                auth_header.merge(headers), options)
        handle_errors(response)
        begin
          MultiJson.load(response.body.to_s)
        rescue MultiJson::LoadError
          response.body
        end
      end
    end

    def self.auth_header
      token.nil? ? {} : {'Authorization' => "GoogleLogin auth=#{token}"}
    end

  private

    def self.handle_errors(response)
      if response.status >= 400
        begin
          response_hash = MultiJson.load(response.body)
        rescue MultiJson::DecodeError
          response_hash = {}
        end

        error_info = {
          'code' => response.status,
          'message' => response_hash['errors']
        }

        if response.status >= 500
          raise Theoldreader::ServerError.new(response.status, response.body, error_info)
        else
          raise Theoldreader::ClientError.new(response.status, response.body, error_info)
        end
      end
    end

    def self.endpoint
      @endpoint ||= self.name.split('::').last.hyphenize
    end

    def self.service
      @service ||= Theoldreader::API::Service.instance
    end

    def self.token
      Theoldreader::Config.token
    end

    def self.format
      'json'
    end

  end
end
