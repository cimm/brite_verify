module BriteVerify
  class Email
    attr_reader :address

    def initialize(address)
      @address = address
    end

    def verify
      email_fetcher = EmailFetcher.new(KEY)
      @raw_email    = email_fetcher.fetch_raw_email(@address)
    end

    def verified_address
      @raw_email["address"]
    end

    def account
      @raw_email["account"]
    end

    def domain
      @raw_email["domain"]
    end

    def status
      @raw_email["status"]
    end

    def connected?
      @raw_email["connected"].downcase == "true"
    end

    def duration
      @raw_email["duration"]
    end

    def disposable?
      @raw_email["disposable"]
    end

    def role_address?
      @raw_email["role_address"]
    end
  end
end
