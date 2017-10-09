require 'tempfile'

module BlackSky
  class Agent
    def initialize(name, renamer, store)
      @name, @renamer, @store = name, renamer, store
      @pg, @thread = nil, nil
    end

    def async(url, headers = {})
      if @thread
        self.cancel()
      end

      @thread = Thread.new do
        begin
          sync(url, headers)
        rescue StandardError => e
          puts e.inspect
          puts e.backtrace
        end
      end
    end

    def sync(url, headers = {})
      @pg = Progress.new(@name)
      with(@name, url, headers) do |file, res|
        @pg.set_total(res['Content-Length'].to_i)

        res.read_body do |chunk|
          file.write(chunk)
          @pg.increment(chunk.bytesize)
        end

        @renamer.copy(file.path, @name)
      end
    end

    def to_h()
      @pg&.to_h || {name: @name, total: 0, size: 0}
    end

    def cancel()
      @thread&.kill()
      @thread, @pg = nil, nil
    end

    private
    def with_temp(&block)
      Tempfile.open("black_sky-", &block)
    end

    def with_store(name, &block)
      uuid = SecureRandom.uuid
      @store.bracket(uuid, self, &block)
    end

    def with(name, url, headers, &block)
      with_store(name) do
        with_temp do |file|
          Request.new(url, headers).with do |res|
            block.(file, res)
          end
        end
      end
    end
  end
end
