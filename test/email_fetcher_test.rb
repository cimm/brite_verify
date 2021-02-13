require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

module BriteVerify
  describe EmailFetcher do
    ADDRESS = "john.doe@example.com"
    KEY     = "123-abc-123-abc"

    before do
      @email_verification_request = stub_email_verification_request(ADDRESS, KEY, valid_email_body)
    end

    it "accepts a key" do
      email_fetcher = EmailFetcher.new(KEY)
      _(email_fetcher).wont_be_nil
    end

    it "requires a key" do
      fetcher = lambda { EmailFetcher.new }
      _(fetcher).must_raise(ArgumentError)
    end

    describe :fetch_raw_email do
      it "returns the raw e-mail" do
        email_fetcher           = EmailFetcher.new(KEY)
        parsed_valid_email_body = JSON.parse(valid_email_body)
        _(email_fetcher.fetch_raw_email(ADDRESS)).must_equal(parsed_valid_email_body)
      end
    end

    describe :fetch_email do
      it "verifies the e-mail with BriteVerify" do
        email_fetcher = EmailFetcher.new(KEY)
        email_fetcher.fetch_email(ADDRESS)
        assert_requested(@email_verification_request)
      end

      it "returns an e-mail response" do
        email_fetcher = EmailFetcher.new(KEY)
        _(email_fetcher.fetch_email(ADDRESS)).must_be_instance_of(EmailResponse)
      end
    end

    describe :verification_uri do
      it "returns the verification URI" do
        email_fetcher = EmailFetcher.new(KEY)
        uri = email_fetcher.verification_uri(ADDRESS)
        _(uri.to_s).must_equal("https://bpi.briteverify.com/emails.json?address=john.doe%40example.com&apikey=123-abc-123-abc")
      end
    end
  end
end
