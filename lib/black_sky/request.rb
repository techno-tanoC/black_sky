require 'net/http'
require 'uri'

module BlackSky
  class Request
    def initialize(url, headers, &block)
      uri = URI.parse(url)
      request(uri, headers, &block)
    end

    private
    def request(uri, headers, limit = 10, &block)
      req = Net::HTTP::Get.new(uri.path, headers)

      build_http(uri).request_get(uri.path, headers) do |res|
        case res
        when Net::HTTPSuccess
          block.(res)
        when Net::HTTPRedirection
          redirect(res, uri, headers, limit, &block)
        else
          $BLACK_SKY_WARN_LOGGER.warn "request is not success nor redirection: #{uri}"
        end
      end
    end

    def redirect(res, uri, headers, limit, &block)
      raise ArgumentError, "too many HTTP redirects" if limit.zero?

      new_uri = URI.parse(res['location'])
      if new_uri.relative?
        new_uri = uri + new_uri
      end

      # headers['Cookie'] = res['Set-Cookie'] if res['Set-Cookie']

      $BLACK_SKY_WARN_LOGGER.warn "redirect to #{new_uri}"
      request(new_uri, headers, limit - 1, &block)
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
