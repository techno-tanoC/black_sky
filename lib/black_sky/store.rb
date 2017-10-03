module BlackSky
  class Store
    def initialize()
      @store, @mutex = {}, Mutex.new
    end

    def store(key, val)
      sync { @store[key] = val }
    end

    def delete(key)
      sync { @store.delete(key) }
    end

    def fetch(key)
      sync { @store[key] }
    end

    def all
      sync { @store }
    end

    private
    def sync(&block)
      @mutex.synchronize(&block)
    end
  end
end
