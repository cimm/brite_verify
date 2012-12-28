require "net/https"
require "openssl"
require "uri"

module BriteVerify
  class EmailFetcher
    EMAIL_PATH = "/email.json"

    def initialize(key)
      @key = key
    end

    def fetch_raw_email
      email_response = fetch(email_address)
      email_response.raw_email
    end

    def fetch(email_address)
      uri              = verification_uri
      http             = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      request          = Net::HTTP::Get.new(uri.request_uri)
      response         = http.request(request)
      EmailResponse.new(response)
    end

    def verification_uri(email_address)
      query = URI.encode_www_form(address: email_address, apikey: @key)
      URI::HTTPS.build({host: HOST, path: EMAIL_PATH, query: query})
    end
  end
end
