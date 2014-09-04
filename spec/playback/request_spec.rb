require 'spec_helper'
require 'playback/request'

describe Playback::Request do
  let :lines do
    [
      '120.180.129.122 - - [07/Jun/2014:14:58:55 +0900] "GET /category/games HTTP/1.1" 200 52 "/category/giftcards" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"',
      '140.183.116.188 - - [07/Jun/2014:14:58:55 +0900] "GET /category/books HTTP/1.1" 200 73 "/category/electronics" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; GTB7.2; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C)"',
      '156.180.140.212 - - [07/Jun/2014:14:58:55 +0900] "POST /search/?c=Jewelry+Networking HTTP/1.1" 200 118 "/item/games/1005" "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3"',
      '24.126.122.134 - - [07/Jun/2014:14:58:55 +0900] "POST /search/?c=Books HTTP/1.1" 200 53 "/search/?c=Games" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"',
      '216.60.121.179 - - [07/Jun/2014:14:58:55 +0900] "GET /category/garden HTTP/1.1" 200 78 "/item/toys/375" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"',
      '48.120.24.63 - - [07/Jun/2014:14:58:55 +0900] "GET /category/electronics HTTP/1.1" 200 103 "/category/toys" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; BTRS122159; GTB7.2; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; BRI/2)"',
      '208.51.21.113 - - [07/Jun/2014:14:58:55 +0900] "GET /category/toys HTTP/1.1" 200 132 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"'
    ]
  end

  let(:io) { StringIO.new(lines.join("\n")) }
  let(:log_path) { 'access.log' }

  it 'has a version number' do
    expect(Playback::VERSION).not_to be nil
  end

  it 'can parse common format log' do
    request = Playback::Request.new('http://localhost', log_path, 'apache')
    #puts request.exec

    expect(request.exec).to be(result)
  end
end
