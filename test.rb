require 'pp'
require 'black_sky'

$store = BlackSky::Store.new
$renamer = BlackSky::Renamer.new(".")
$downloader = BlackSky::Downloader.new(".")

def sync
  BlackSky::Agent.new("morikubo", $renamer, $store).sync("https://pbs.twimg.com/media/DIQLWnUXUAITljJ.jpg")
end

def async
  $downloader.download("morikubo", "https://pbs.twimg.com/media/DIQLWnUXUAITljJ.jpg")
end

async()

sleep 10

loop do
  pp($store.all.map do |key, agent|
    agent.to_h.merge({id: key})
  end)

  $store.all.map do |key, agent|
    agent.cancel
  end
  
  sleep 1
end
