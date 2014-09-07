# Playback

generate and execute http request from access log

## Installation

    $ gem install playback

## Usage

### as a command line tool
```sh
playback 'http://httpbin.org' /path/to/access.log
#=> { "method": "GET", "path": "/get", status: 200 }
#=> { "method": "POST", "path": "/post?hoge=1", status: 200 }
#=> { "method": "PUT", "path": "/put?foo=bar", status: 200 }
#=> :
#=> :
```

### as a part of code
```ruby
require 'playback'

p = Playback::Request.new('http://httpbin.org')
File.open '/path/to/access.log' do |file|
  file.each_line do |line|
    puts p.run(line)   #=> { "method": "GET", "path": "/get", status: 200 }
  end
end
```

## Contributing

1. Fork it ( https://github.com/takady/playback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
