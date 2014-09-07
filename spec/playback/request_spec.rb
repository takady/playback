require 'spec_helper'
require 'playback/request'
require 'json'

describe Playback::Request do

  def create_file(path, lines)
    File.open path, 'w' do |file|
      lines.each do |line|
        file.puts line
      end
    end
  end

  let(:base_uri) { 'http://httpbin.org' }

  let :apache_common_log_lines do
    [
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "GET /get HTTP/1.1" 200 73',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "POST /post?c=Jewelry+Networking HTTP/1.1" 200 118',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PUT /put?c=Books HTTP/1.1" 200 53',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "DELETE /delete HTTP/1.1" 200 53',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PATCH /patch?from=0 HTTP/1.1" 200 53',
    ]
  end
  let :apache_combined_log_lines do
    [
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "GET /get HTTP/1.1" 200 73 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "POST /post?c=Jewelry+Networking HTTP/1.1" 200 118 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PUT /put?c=Books HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "DELETE /delete HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
      '127.0.0.1 - - [07/Jun/2014:14:58:55 +0900] "PATCH /patch?from=0 HTTP/1.1" 200 53 "http://google.co.jp" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"',
    ]
  end
  let(:apache_common_log_file) { './apache_common_access.log' }
  let(:apache_combined_log_file) { './apache_combined_access.log' }

  before do
    create_file(apache_common_log_file, apache_common_log_lines)
    create_file(apache_combined_log_file, apache_combined_log_lines)
  end

  after do
    File.unlink apache_common_log_file
    File.unlink apache_combined_log_file
  end

  it 'can generate and request from apache common format log' do
    req = Playback::Request.new(base_uri, apache_common_log_file, 'common')
    res = req.run

    res.each do |r|
      expect(r.class).to eq(Net::HTTPOK)
      headers = JSON.load(r.body)['headers']
      expect(headers['Referer']).to eq('')
      expect(headers['User-Agent']).to eq(Playback::Request::DEFAULT_USER_AGENT)
    end
  end

  it 'can generate and request from apache combined format log' do
    req = Playback::Request.new(base_uri, apache_combined_log_file, 'combined')
    res = req.run

    res.each do |r|
      expect(r.class).to eq(Net::HTTPOK)
      headers = JSON.load(r.body)['headers']
      expect(headers['Referer']).to eq('http://google.co.jp')
      expect(headers['User-Agent']).to eq('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1')
    end
  end

end
