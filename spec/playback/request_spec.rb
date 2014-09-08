require 'spec_helper'
require 'playback/request'
require 'json'

describe Playback::Request do
  let(:apache_log_playback) { Playback::Request.new('http://httpbin.org') }
  let :apache_common_logs do
    {
      GET:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "GET /get HTTP/1.1" 200 73',
      POST:   '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "POST /post?c=Jewelry+Networking HTTP/1.1" 200 118',
      PUT:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PUT /put?c=Books HTTP/1.1" 200 53',
      DELETE: '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "DELETE /delete HTTP/1.1" 200 53',
      PATCH:  '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PATCH /patch?from=0 HTTP/1.1" 200 53',
    }
  end
  let :apache_combined_logs do
    {
      GET:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "GET /get HTTP/1.1" 200 73 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      POST:   '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "POST /post?c=Jewelry+Networking HTTP/1.1" 200 118 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      PUT:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PUT /put?c=Books HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      DELETE: '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "DELETE /delete HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      PATCH:  '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PATCH /patch?from=0 HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
    }
  end
  let :apache_custom_logs do
    {
      GET:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "GET /get HTTP/1.1" 200 73 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1" "example.com" "192.168.0.1201102091208001" "901"',
      POST:   '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "POST /post?c=Jewelry+Networking HTTP/1.1" 200 118 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1" "example.com" "192.168.0.1201102091208001" "901"',
      PUT:    '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PUT /put?c=Books HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1" "example.com" "192.168.0.1201102091208001" "901"',
      DELETE: '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "DELETE /delete HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1" virtualhost.example.jp "192.0.2.16794832933550" "09011112222333_xx.ezweb.ne.jp" 533593',
      PATCH:  '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PATCH /patch?from=0 HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1" virtualhost.example.jp "192.0.2.16794832933550" "09011112222333_xx.ezweb.ne.jp" 533593',
    }
  end

  it 'can get request from apache common format log' do
    res = apache_log_playback.run(apache_common_logs[:GET])
    expect(res).to eq('{"method":"GET","path":"/get","status":200}')
  end

  it 'can get request from apache combined format log' do
    res = apache_log_playback.run(apache_combined_logs[:GET])
    expect(res).to eq('{"method":"GET","path":"/get","status":200}')
  end

  it 'can get request from apache customized format log' do
    res = apache_log_playback.run(apache_custom_logs[:GET])
    expect(res).to eq('{"method":"GET","path":"/get","status":200}')
  end

  it 'can post request from apache common format log' do
    res = apache_log_playback.run(apache_common_logs[:POST])
    expect(res).to eq('{"method":"POST","path":"/post?c=Jewelry+Networking","status":200}')
  end

  it 'can post request from apache combined format log' do
    res = apache_log_playback.run(apache_combined_logs[:POST])
    expect(res).to eq('{"method":"POST","path":"/post?c=Jewelry+Networking","status":200}')
  end

  it 'can post request from apache customized format log' do
    res = apache_log_playback.run(apache_custom_logs[:POST])
    expect(res).to eq('{"method":"POST","path":"/post?c=Jewelry+Networking","status":200}')
  end

  it 'can put request from apache common format log' do
    res = apache_log_playback.run(apache_common_logs[:PUT])
    expect(res).to eq('{"method":"PUT","path":"/put?c=Books","status":200}')
  end

  it 'can put request from apache combined format log' do
    res = apache_log_playback.run(apache_combined_logs[:PUT])
    expect(res).to eq('{"method":"PUT","path":"/put?c=Books","status":200}')
  end

  it 'can put request from apache customized format log' do
    res = apache_log_playback.run(apache_custom_logs[:PUT])
    expect(res).to eq('{"method":"PUT","path":"/put?c=Books","status":200}')
  end

  it 'can delete request from apache common format log' do
    res = apache_log_playback.run(apache_common_logs[:DELETE])
    expect(res).to eq('{"method":"DELETE","path":"/delete","status":200}')
  end

  it 'can delete request from apache combined format log' do
    res = apache_log_playback.run(apache_combined_logs[:DELETE])
    expect(res).to eq('{"method":"DELETE","path":"/delete","status":200}')
  end

  it 'can delete request from apache customized format log' do
    res = apache_log_playback.run(apache_custom_logs[:DELETE])
    expect(res).to eq('{"method":"DELETE","path":"/delete","status":200}')
  end

  it 'can patch request from apache common format log' do
    res = apache_log_playback.run(apache_common_logs[:PATCH])
    expect(res).to eq('{"method":"PATCH","path":"/patch?from=0","status":200}')
  end

  it 'can patch request from apache combined format log' do
    res = apache_log_playback.run(apache_combined_logs[:PATCH])
    expect(res).to eq('{"method":"PATCH","path":"/patch?from=0","status":200}')
  end

  it 'can patch request from apache customized format log' do
    res = apache_log_playback.run(apache_custom_logs[:PATCH])
    expect(res).to eq('{"method":"PATCH","path":"/patch?from=0","status":200}')
  end

end
