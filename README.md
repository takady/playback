# Playback

generate and execute http request from access log

## Installation

    $ gem install playback

## Usage

```ruby
require 'playback/request'

# initialize with base-uri, log file path and log file format
# supported log format: apache(common & combined)
request = Playback::Request.new('http://httpbin.org', '/path/to/access.log', 'combined')
req = request.run        # execute http request from whole access log file
req.class                # Array
req[0].class             # Net::HTTPOK or something of the child class of Net:HTTP
```

## Contributing

1. Fork it ( https://github.com/takady/playback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
