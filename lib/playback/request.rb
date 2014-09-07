require "playback/parser"
require 'net/http'
require 'json'

module Playback
  class Request
    DEFAULT_CONTENT_TYPE = 'application/text'
    DEFAULT_USER_AGENT = 'From Playback rubygems'

    def initialize(base_uri)
      @base_uri = base_uri
      @parser = Playback::Parser
    end

    def run(line, return_type='')
      parsed_line = parse(line)
      method = parsed_line[:request][:method]
      path   = parsed_line[:request][:path]
      referer = parsed_line[:referer] ||= ''
      user_agent = parsed_line[:user_agent] ||= DEFAULT_USER_AGENT

      res = request(method, path, referer, user_agent)

      unless (return_type == 'net-http')
        result = {
          method: method,
          path: path,
          status: res.code.to_i,
        }
        res = JSON.generate result
      end

      res
    end

    def parse(line)
      begin
        @parser.parse(line.chomp, 'combined')
      rescue Exception => e
        begin
          @parser.parse(line.chomp, 'common')
        rescue Exception => e
          puts 'error'
        end
      end
    end

    def request(method, path, referer, user_agent)
      uri = URI.parse(@base_uri + path)
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

    private :parse, :request
  end
end
