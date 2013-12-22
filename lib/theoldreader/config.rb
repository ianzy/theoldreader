require 'yaml'

module Theoldreader
  class Config
    class << self
      attr_accessor :token
      def load
        @config ||= YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'theoldreader.yml'))
      rescue Errno::ENOENT
        {}
      end

      def token
        @token ||= load['token']
      end
    end
  end
end
