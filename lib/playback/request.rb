module Playback
  class Request

    def initialize(log, format)
      @log = log
      @format = format
    end

    def exec
      request
    end

    def exec_all
      request 'all'
    end

    def request(times='')
      File.open @log do |file|
        file.each_line do |line|
          puts parse(line).chomp
          break unless times == 'all'
        end
      end
    end

    def parse(line)
      pattern_str = '.+\s+.+\s+.+\s+\[.+\]\s+"(\S+\s\S+\s\S+)"\s+.+'
      pattern = /^#{pattern_str}$/

      matched = pattern.match(line)
      matched.to_a[1]
    end

  end
end
