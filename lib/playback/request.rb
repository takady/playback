require 'net/http'

module Playback
  class Request

    def initialize(uri, log, format)
      @uri = uri
      @log = log
      @format = format
    end

    def exec
      run
    end

    def exec_all
      run 'all'
    end

    def run(times='')
      File.open @log do |file|
        file.each_line do |line|
          puts request(parse_log(line))
          break unless times == 'all'
        end
      end
    end

    def parse_log(line)
      pattern_str = '.+\s+.+\s+.+\s+\[.+\]\s+"(\S+\s\S+\s\S+)"\s+.+'
      pattern = /^#{pattern_str}$/

      matched = parse_request(pattern.match(line).to_a[1])
      matched[:path]
    end

    def parse_request(str)
      method, path, protocol = str.split
      {
        method:   method,
        path:     path,
        protocol: protocol
      }
    end

    def request(path)
      url = URI.parse(@uri + path)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      res.body
    end

  end
end
