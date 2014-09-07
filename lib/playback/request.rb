require 'net/http'
require 'apache_log/parser'

module Playback
  class Request
    DEFAULT_CONTENT_TYPE = 'application/text'
    DEFAULT_USER_AGENT = 'From Playback rubygems'

    def initialize(uri, log, format)
      @uri = uri
      @log = log
      @format = format
      @parser = ApacheLog::Parser
    end

    def run
      responses = []
      File.open @log do |file|
        file.each_line do |line|
          parsed_line = @parser.parse(line.chomp, @format)
           response = request(parsed_line[:request][:method], parsed_line[:request][:path],
                               parsed_line[:referer] ||= '', parsed_line[:user_agent] ||= DEFAULT_USER_AGENT)
           responses.push response
        end
      end
      responses
    end

    def request(method, path, referer='', user_agent=DEFAULT_USER_AGENT)
      uri = URI.parse(@uri + path)
      http = Net::HTTP.new(uri.host, uri.port)
      query = uri.query.nil? ? '' : uri.query
      data = {'Content-Type' => DEFAULT_CONTENT_TYPE, 'Referer' => referer, 'User-Agent' => user_agent}

      case method
      when 'GET'
        http.get(uri.path + query, data)
      when 'POST'
        http.post(uri.path, query, data)
      when 'PUT'
        http.put(uri.path, query, data)
      when 'DELETE'
        http.delete(uri.path + query, data)
      when 'PATCH'
        http.patch(uri.path, query, data)
      else
        # error
      end
    end

  end
end
