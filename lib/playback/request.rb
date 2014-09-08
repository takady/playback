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

    rescue => e
      e.message
    end

    def parse(line)
      begin
        @parser.parse(line.chomp, 'combined')
      rescue
        begin
          @parser.parse(line.chomp, 'common')
        rescue => e
          raise e
        end
      end
    end

    def request(method, path, referer, user_agent)
      begin
        uri = URI.parse(@base_uri + path)
      rescue
        raise "it can not be recognized as a uri: <#{@base_uri + path}>"
      end

      http = Net::HTTP.new(uri.host, uri.port)
      query = uri.query ||= ''
      data = {'Content-Type' => DEFAULT_CONTENT_TYPE, 'Referer' => referer, 'User-Agent' => user_agent}

      case method
      when 'GET'
        http.get(path, data)
      when 'POST'
        http.post(uri.path, query, data)
      when 'PUT'
        http.put(uri.path, query, data)
      when 'DELETE'
        http.delete(path, data)
      when 'PATCH'
        http.patch(uri.path, query, data)
      when 'HEAD'
        http.head(path, data)
      else
        raise "it is not supported http method: <#{method}>"
      end
    end

    private :parse, :request
  end
end
