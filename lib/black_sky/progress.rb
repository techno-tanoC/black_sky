module BlackSky
  class Progress
    def initialize(name)
      @name, @total, @size, @mutex = name, 0, 0, Mutex.new
    end

    def set_total(total)
      sync { @total = total }
    end

    def increment(size)
      sync { @size = @size + size }
    end

    private
    def sync(&block)
      @mutex.synchronize(&block)
    end
  end
end
