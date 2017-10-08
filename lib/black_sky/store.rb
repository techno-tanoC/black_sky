module BlackSky
  class Store
    def initialize()
      @store, @mutex = {}, Mutex.new
    end

    def all
      sync { @store }
    end

    def fetch(key)
      sync { @store[key] }
    end

    def add(key, val)
      sync { @store[key] = val }
    end

    def store(val)
      uuid = SecureRandom
      self.add(uuid, val)
    end

    def delete(key)
      sync { @store.delete(key) }
    end

    def bracket(key, val, &block)
      self.add(key, val)
      block.(key, val)
    ensure
      self.delete(key)
    end

    private
    def sync(&block)
      @mutex.synchronize(&block)
    end
  end
end
