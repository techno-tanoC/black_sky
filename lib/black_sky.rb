require 'black_sky/version'
Dir["#{File.dirname(__FILE__)}/black_sky/*.rb"].sort.each do |path|
  require "black_sky/#{File.basename(path, '.rb')}"
end

module BlackSky
  class Downloader
    def initialize
      @store = Store.new
      @renamer = Renamer.new
    end

    def with_temp(&block)
      Tempfile.open("black_sky-", &block)
    end

    def with_progress(key, name, before, after, &block)
      pg = BlackSky::Progress.new(name)
      before.call(pg)
      block.call(pg)
    ensure
      after.call(pg)
    end
  end
end
