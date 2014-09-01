# Playback

generate and execute http request from access log

## Installation

    $ gem install playback

## Usage

```ruby
require 'playback'

# support log format: apache(common & combined)
request = Playback::Request.new('/path/to/access.log', 'apache')
request.exec        # execute only one http request
request.exec_all    # execute whole http request
```

## Contributing

1. Fork it ( https://github.com/takady/playback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
