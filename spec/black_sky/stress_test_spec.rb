RSpec.describe "stress test" do
  # let(:url) { "http://www.example.com/" }
  # let(:content) { File.read("#{File.dirname(__FILE__)}/../fixture/morikubo.jpg") }
  # let(:request) { BlackSky::Request.new(url, {}) }
  #
  # before do
  #   WebMock.enable!
  #   WebMock
  #     .stub_request(:get, url)
  #     .to_return(body: content, status: 200, headers: {"Content-Length": content.bytesize})
  # end
  #
  # it do
  #   d = BlackSky::Downloader.new("./tmp")
  #   1000.times do
  #     d.download("morikubo", url)
  #     sleep 0.03
  #   end
  #
  #   puts "end 1000 times"
  #   $stdin.gets
  #   p GC.stat
  #   $stdin.gets
  # end
end
