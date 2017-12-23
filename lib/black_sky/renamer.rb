module BlackSky
  class Renamer
    def initialize(dest)
      @dest, @mutex = dest, Mutex.new
    end

    def rename(from, name)
      sync do
        fresh = fresh_name(name, ext)
        File.rename(from, fresh)
      end
    end

    def copy(from, name, ext)
      sync do
        fresh = fresh_name(name, ext)
        FileUtils.copy(from, fresh)
        FileUtils.chown(1000, 1000, fresh)
        FileUtils.chmod(0600, fresh)
      end
    end

    private
    def fresh_name(name, ext, count = 0)
      new_name = build_path(name, ext, count)
      if File.exist?(new_name)
        fresh_name(name, ext, count + 1)
      else
        new_name
      end
    end

    def build_path(name, ext, count)
      File.join(@dest, build_name(name, ext, count))
    end

    def build_name(name, ext, count)
      tail = (ext.nil? || ext == "") ? "" : ".#{ext}"
      name + (count.zero? ? "" : "(#{count})") + tail
    end

    def sync(&block)
      @mutex.synchronize(&block)
    end
  end
end
