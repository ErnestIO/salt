# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'net/https'
require 'json'

module Salt
  class Connection
    DEFAULT_ENDPOINT = '127.0.0.1'.freeze
    DEFAULT_PORT = '8000'.freeze
    DEFAULT_USERNAME = 'salt'.freeze

    def initialize(args)
      @config = args
    end

    def get(uri)
      http_request = Net::HTTP::Get.new request_uri(uri)
      request(http_request, request_uri(uri))
    end

    def post(uri, data, salt_response = true, authenticated = true)
      http_request = Net::HTTP::Post.new request_uri(uri)
      http_request.set_form_data data
      request(http_request, request_uri(uri), salt_response, authenticated)
    end

    private

    def request_uri(uri)
      URI("https://#{endpoint}#{uri}")
    end

    def port
      port_number = DEFAULT_PORT
      port_number = @config[:port] if @config[:port]
      port_number
    end

    def endpoint
      host = DEFAULT_ENDPOINT
      host = @config[:endpoint] if @config[:endpoint]
      "#{host}:#{port}"
    end

    def username
      user = DEFAULT_USERNAME
      user = @config[:user] if @config[:user]
      user
    end

    def password
      raise ArgumentError, 'No password specified' if @config[:pass].nil?
      @config[:pass]
    end

    def auth
      credentials = { 'username' => username, 'password' => password, 'eauth' => 'pam' }
      response = post('/login', credentials, false, false)
      raise 'Authentication failed, invalid credentials' if response.code != '200'
      JSON.parse(response.body)['return'].first['token']
    end

    def token
      @token ||= auth
    end

    def get_http_args(uri)
      [
        uri.hostname,
        uri.port,
        use_ssl: uri.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      ]
    end

    def request(request, uri, salt_response = true, authenticated = true)
      request['Accept'] = 'application/json'
      request['X-Auth-Token'] = token if authenticated
      args = get_http_args(uri)
      response = Net::HTTP.start(*args) { |http| http.request(request) }
      raise 'Server did not return a response body' if response.body.nil?
      if salt_response
        Salt::Response.new(response)
      else
        response
      end
    end
  end
end
