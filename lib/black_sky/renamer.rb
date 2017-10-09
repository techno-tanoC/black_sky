module BlackSky
  class Renamer
    def initialize(dest)
      @dest, @mutex = dest, Mutex.new
    end

    def rename(from, name)
      sync do
        fresh = fresh_name(name)
        #todo exception
        File.rename(from, fresh)
      end
    end

    def copy(from, name)
      sync do
        fresh = fresh_name(name)
        FileUtils.copy(from, fresh)
        File.chown(1000, 1000, fresh)
        File.chmod(0600, fresh)
      end
    end

    private
    def fresh_name(name, ext = "mp4", count = 0)
      new_name = new_name(name, ext, count)
      if File.exist?(new_name)
        fresh_name(name, ext, count + 1)
      else
        new_name
      end
    end

    def new_name(name, ext, count)
      if count.zero?
        File.join(@dest, "#{name}.#{ext}")
      else
        File.join(@dest, "#{name}(#{count}).#{ext}")
      end
    end

    def sync(&block)
      @mutex.synchronize(&block)
    end
  end
end
