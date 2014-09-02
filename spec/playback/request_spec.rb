require 'spec_helper'
require 'playback/request'

describe Playback::Request do

  it 'has a version number' do
    expect(Playback::VERSION).not_to be nil
  end

  it 'can parse common format log' do
    request = Playback::Request.new('/private/var/log/apache2/access_log', 'apache')
    puts request.exec
  end
end
