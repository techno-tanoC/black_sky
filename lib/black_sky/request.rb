require 'addressable'
require 'net/http'
require 'uri'

module BlackSky
  class Request
    def initialize(url, headers)
      @url, @headers = url, headers
    end

    def with(&block)
      request(@url, @headers, &block)
    end

    private
    def request(url, headers, limit = 10, &block)
      uri = Addressable::URI.parse(url)
      req = Net::HTTP::Get.new(uri.path, headers)

      build_http(uri).request_get(uri.path, headers) do |res|
        case res
        when Net::HTTPSuccess
          block.(res)
        when Net::HTTPRedirection
          redirect(res, url, headers, limit, &block)
        else
          warn "request is not success nor redirection"
        end
      end
    end

    def redirect(res, url, headers, limit, &block)
      raise ArgumentError, "too many HTTP redirects" if limit.zero?

      location = res['location']
      warn "redirect to #{location}"
      request(location, headers, limit - 1, &block)
    end


    def build_http(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          # http.ca_file = "cacert.pem"
        end
      end
    end
  end
end
