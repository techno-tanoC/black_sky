require 'securerandom'
require 'logger'

require 'black_sky/version'
require 'black_sky/request'
require 'black_sky/progress'
require 'black_sky/store'
require 'black_sky/renamer'
require 'black_sky/agent'

$BLACK_SKY_ERROR_LOGGER = Logger.new("error.log", shift_age = "daily")
$BLACK_SKY_WARN_LOGGER = Logger.new("warn.log", shift_age = "daily")

module BlackSky
  class Downloader
    def initialize(storage_path)
      @renamer = Renamer.new(storage_path)
      @store = Store.new
    end

    def download(name, ext, url, headers = {})
      Agent.new(name, ext, @renamer, @store).async(url, headers)
    end

    def all()
      @store.all.map do |key, agent|
        agent.to_h.merge({id: key})
      end
    end

    def cancel(key)
      @store.fetch(key).cancel()
    end
  end
end
