require 'net/https'
require 'openssl'
require 'uri'

module BriteVerify
  class EmailFetcher
    EMAIL_PATH = "/emails.json"

    def initialize(key)
      @key = key
    end

    def fetch_raw_email(address)
      email_response = fetch_email(address)
      email_response.raw_email
    rescue Timeout::Error
      {}
    end

    def fetch_email(address)
      uri                   = verification_uri(address)
      http                  = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl          = true
      http.continue_timeout = ENV.fetch("BRITEVERIFY_CONTINUE_TIMEOUT", 60).to_i
      http.open_timeout     = ENV.fetch("BRITEVERIFY_OPEN_TIMEOUT", 60).to_i
      http.read_timeout     = ENV.fetch("BRITEVERIFY_READ_TIMEOUT", 60).to_i
      http.verify_mode      = OpenSSL::SSL::VERIFY_PEER
      request               = Net::HTTP::Get.new(uri.request_uri)
      response              = http.request(request)
      EmailResponse.new(response)
    end

    def verification_uri(address)
      query = URI.encode_www_form(address: address, apikey: @key)
      URI::HTTPS.build({host: HOST, path: EMAIL_PATH, query: query})
    end
  end
end
