require 'tempfile'

module BlackSky
  class Agent
    def initialize(name, renamer, store)
      @name, @renamer, @store = name, renamer, store
      @thread, @pg = nil, nil
    end

    def start(url, headers = {})
      if @thread
        self.cancel()
      end

      @thread = Thread.new do
        sync(url, headers)
      end
    end

    def sync(url, headers = {})
      with(@name, url, headers) do |key, pg, res, file|
        @pg = pg
        pg.set_total(res['Content-Length'].to_i)

        res.read_body do |chunk|
          file.write(chunk)
          pg.increment(chunk.bytesize)
        end

        @renamer.rename(file.path, @name)
      end
    end

    def cancel()
      @thread&.kill()
      @thread, @pg = nil, nil
    end

    private
    def with_temp(&block)
      Tempfile.open("black_sky-", &block)
    end

    def with_key_progress(name, &block)
      uuid = SecureRandom.uuid
      pg = Progress.new(@name)
      @store.bracket(uuid, pg, &block)
    end

    def with(name, url, headers, &block)
      with_key_progress(name) do |key, pg|
        with_temp do |file|
          Request.new(url, headers).with do |res|
            block.(key, pg, res, file)
          end
        end
      end
    end
  end
end
