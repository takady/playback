require 'apache_log/parser'
require 'net/http'
require 'json'

module Playback
  class Request
    DEFAULT_CONTENT_TYPE = 'application/text'
    DEFAULT_USER_AGENT = 'From Playback rubygems'
    PARSER = ApacheLog::Parser

    def initialize(base_uri)
      @base_uri = base_uri
      @common_parser = PARSER.new('common')
      @combined_parser = PARSER.new('combined')
    end

    def run(line, return_type='')
      parsed_line = parse(line)

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

    def parse(line)
      begin
        @combined_parser.parse(line.chomp)
      rescue
        begin
          @common_parser.parse(line.chomp)
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
      header = {'Content-Type' => DEFAULT_CONTENT_TYPE, 'Referer' => referer, 'User-Agent' => user_agent}

      case method
      when 'GET'
        http.get(path, header)
      when 'POST'
        http.post(uri.path, query, header)
      when 'PUT'
        http.put(uri.path, query, header)
      when 'DELETE'
        http.delete(path, header)
      when 'PATCH'
        http.patch(uri.path, query, header)
      when 'HEAD'
        http.head(path, header)
      else
        raise "it is not supported http method: <#{method}>"
      end
    end
  end
end
