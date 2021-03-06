# frozen_string_literal: true

module Agendor
  class Base
    def initialize(token, username = '', password = '')
      @username = username
      @password = password
      @token = token
    end

    private

    def basic_auth
      auth_str = [@username, @password].join(':')
      "Basic #{Base64.strict_encode64(auth_str)}"
    end

    def token_auth
      "Token #{@token}"
    end

    def headers
      header = { 'Content-Type' => 'application/json' }
      header['Authorization'] = @token.nil? || @token.empty? ? basic_auth : token_auth
      header
    end

    def api_path
      'https://api.agendor.com.br/v1'
    end

    def client
      @client ||= Faraday.new do |conn|
        conn.headers = {'Content-Type' => 'application/json'}
        conn.adapter Faraday.default_adapter
      end
    end
  end

  class UnauthorizedError < StandardError
    attr_reader :response

    def initialize(_message = 'Unauthorized request', response)
      @response = response
    end
  end
end
