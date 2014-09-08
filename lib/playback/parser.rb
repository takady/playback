module Playback
  module Parser

    def self.parse(line, format)
      common_fields   = %w(request)
      combined_fields = common_fields + %w(referer user_agent)

      common_pattern     = '\S+\s+\S+\s+\S+\s+\[.*\]\s+"(\S+\s\S+\s\S+)"\s+\S+\s+\S+'
      combined_pattern   = common_pattern + '\s+"([^"]*)"\s+"([^"]*)".*'

      case format
      when 'common'
        fields = common_fields
        pattern = /^#{common_pattern}$/
      when 'combined'
        fields = combined_fields
        pattern = /^#{combined_pattern}$/
      else
        raise "no such format: <#{format}>"
      end

      matched = pattern.match(line)
      raise "parse error at line: <#{line}>" if matched.nil?

      generate_hash(fields, matched.to_a)
    end

    def self.generate_hash(keys, values)
      hash = {}

      keys.each.with_index do |key, idx|
        key = key.to_sym
        if (key == :request)
          hash[key] = parse_request(values[idx+1])
        else
          hash[key] = values[idx+1]
        end
      end

      hash
    end

    def self.parse_request(str)
      method, path, protocol = str.split
      {
        method:   method,
        path:     path,
        protocol: protocol,
      }
    end

    private_class_method :generate_hash, :parse_request
  end
end
