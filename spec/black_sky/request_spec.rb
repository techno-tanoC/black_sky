require 'spec_helper'

RSpec.describe BlackSky::Request do
  let(:url) { "http://www.example.com/" }
  let(:content) { File.read("#{File.dirname(__FILE__)}/../fixture/morikubo.jpg") }

  before do
    WebMock.enable!
    WebMock
      .stub_request(:get, url)
      .to_return(body: content, status: 200, headers: {"Content-Length": content.bytesize})
  end

  describe "#new" do
    it "has Content-Length" do
      BlackSky::Request.new(url, {}) do |res|
        cl = res['Content-Length']
        expect(cl).to eq(content.bytesize.to_s)
      end
    end

    it "reads contents" do
      chunks = []
      BlackSky::Request.new(url, {}) do |res|
        res.read_body do |chunk|
          chunks << chunk
        end
      end

      expect(chunks.join).to eq(content)
    end
  end
end
