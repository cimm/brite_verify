module BriteVerify
  class Email
    def initialize(address, key = ENV['BRITEVERIFY_API_KEY'])
      raise ArgumentError, "Missing BriteVerify API key" if key.nil? || key.strip.empty?
      @address = address
      @key     = key
    end

    def verified?
      raw_email.keys.any?
    end

    def address
      raw_email["address"]
    end

    def account
      raw_email["account"]
    end

    def domain
      raw_email["domain"]
    end

    def status
      raw_email["status"].to_sym if raw_email["status"]
    end

    def connected
      raw_email["connected"].downcase == "true" if raw_email["connected"]
    end

    def duration
      raw_email["duration"]
    end

    def disposable
      raw_email["disposable"]
    end

    def role_address
      raw_email["role_address"]
    end

    def error_code
      raw_email["error_code"]
    end

    def error
      raw_email["error"]
    end

    private

    def raw_email
      email_fetcher = EmailFetcher.new(@key)
      @raw_email ||= email_fetcher.fetch_raw_email(@address)
    end
  end
end
