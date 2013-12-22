module Theoldreader
  class TheoldreaderError < StandardError; end
  class APIError < TheoldreaderError
    attr_reader :status, :response_body, :errors

    def initialize(status, response_body, errors)
      super("status: #{status}, body: #{response_body}, errors: #{errors.to_s}")
    end
  end

  # Any error with a 5xx HTTP status code
  class ServerError < APIError; end
  # Any error with a 4xx HTTP status code
  class ClientError < APIError; end
end
