require 'apache_log/parser'
require 'net/http'
require 'json'

module Playback
  class Request
    DEFAULT_CONTENT_TYPE = 'application/text'
    DEFAULT_USER_AGENT = 'From Playback rubygems'

    PARSER = ApacheLog::Parser

    REQUEST_WITHOUT_BODY = %w(GET DELETE HEAD)
    REQUEST_WITH_BODY = %w(POST PUT PATCH)

    def initialize(base_uri)
      @base_uri = base_uri
      @common_parser = PARSER.new('common')
      @combined_parser = PARSER.new('combined')
    end

    def run(line, return_type='')
      parsed_line = parse_log(line)

      method     = parsed_line[:request][:method]
      path       = parsed_line[:request][:path]
      referer    = parsed_line[:referer] ||= ''
      user_agent = parsed_line[:user_agent] ||= DEFAULT_USER_AGENT

      response = request(method, path, referer, user_agent)

      return response if return_type == 'net-http'

      {method: method, path: path, status: response.code.to_i}.to_json
    rescue => e
      e.message
    end

    private

    def parse_log(line)
      begin
        @combined_parser.parse(line.chomp)
      rescue
        @common_parser.parse(line.chomp)
      end
    end

    def request(method, path, referer, user_agent)
      uri = URI.parse("#{@base_uri}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      header = {'Content-Type' => DEFAULT_CONTENT_TYPE, 'Referer' => referer, 'User-Agent' => user_agent}

      if REQUEST_WITHOUT_BODY.include?(method)
        http.send(method.downcase, path, header)
      elsif REQUEST_WITH_BODY.include?(method)
        http.send(method.downcase, uri.path, uri.query, header)
      else
        raise "it is not supported http method: <#{method}>"
      end
    end
  end
end
