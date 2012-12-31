require File.expand_path("#{File.dirname(__FILE__)}/test_helper")
require 'json'

module BriteVerify
  describe Email do
    ADDRESS = "john.doe@example.com"
    KEY     = "123-abc-123-abc"

    before do
      stub_email_verification_request(ADDRESS, KEY, valid_email_body)
    end

    it "accepts a key" do
      email = Email.new(ADDRESS, KEY)
      email.wont_be_nil
    end

    it "requires a key" do
      lambda { Email.new(ADDRESS) }.must_raise(ArgumentError)
    end

    it "does not accept an empty key" do
      lambda { Email.new(ADDRESS, "") }.must_raise(ArgumentError)
    end

    it "uses the environment variable the key wasn't given" do
      ENV['BRITEVERIFY_API_KEY'] = "456-def-456-def"
      lambda { Email.new(ADDRESS) }.must_be_silent
      ENV['BRITEVERIFY_API_KEY'] = nil
    end

    describe :verified? do
      describe "when the response was successful" do
        it "returns true" do
          email = Email.new(ADDRESS, KEY)
          email.verified?.must_equal(true)
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns false" do
          email = Email.new(ADDRESS, KEY)
          email.verified?.must_equal(false)
        end
      end

      describe "when the response timed out" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, :timeout)
        end

        it "returns false" do
          email = Email.new(ADDRESS, KEY)
          email.verified?.must_equal(false)
        end
      end

      describe "when the response is unauthorized" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 401)
        end

        it "returns false" do
          email = Email.new(ADDRESS, KEY)
          email.verified?.must_equal(false)
        end
      end
    end

    describe :address do
      describe "when the response was successful" do
        it "returns the verified address returned from BriteVerify" do
          email = Email.new(ADDRESS, KEY)
          email.address.must_equal("john.doe@example.com")
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.address.must_be_nil
        end
      end
    end

    describe :account do
      describe "when the response was successful" do
        it "returns the account returned from BriteVerify" do
          email = Email.new(ADDRESS, KEY)
          email.account.must_equal("john.doe")
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.account.must_be_nil
        end
      end
    end

    describe :domain do
      describe "when the response was successful" do
        it "returns the domain returned from BriteVerify" do
          email = Email.new(ADDRESS, KEY)
          email.domain.must_equal("example.com")
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.domain.must_be_nil
        end
      end
    end

    describe :status do
      describe "when the response was successful" do
        describe "when the address is valid" do
          it "returns the valid status" do
            email = Email.new(ADDRESS, KEY)
            email.status.must_equal(:valid)
          end
        end

        describe "when the address is invalid" do
          before do
            stub_email_verification_request(ADDRESS, KEY, invalid_email_body)
          end

          it "returns the invalid status" do
            email = Email.new(ADDRESS, KEY)
            email.status.must_equal(:invalid)
          end
        end

        describe "when the address is unknown" do
          before do
            stub_email_verification_request(ADDRESS, KEY, unknown_email_body)
          end

          it "returns the unknown status" do
            email = Email.new(ADDRESS, KEY)
            email.status.must_equal(:unknown)
          end
        end

        describe "when the address is an accept all address" do
          before do
            stub_email_verification_request(ADDRESS, KEY, accept_all_email_body)
          end

          it "returns the unknown status" do
            email = Email.new(ADDRESS, KEY)
            email.status.must_equal(:accept_all)
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.status.must_be_nil
        end
      end
    end

    describe :connected do
      describe "when the response was successful" do
        describe "when the address is connected" do
          before do
            stub_email_verification_request(ADDRESS, KEY, connected_email_body)
          end

          it "returns true" do
            email = Email.new(ADDRESS, KEY)
            email.connected.must_equal(true)
          end
        end

        describe "when it is not known if the address is connected" do
          it "returns nil" do
            email = Email.new(ADDRESS, KEY)
            email.connected.must_be_nil
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.connected.must_be_nil
        end
      end
    end

    describe :duration do
      describe "when the response was successful" do
        it "returns the time it took BriteVerify to verify the address" do
          email = Email.new(ADDRESS, KEY)
          email.duration.must_equal(0.104516605)
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.duration.must_be_nil
        end
      end
    end

    describe :disposable do
      describe "when the response was successful" do
        describe "the address is disposable" do
          before do
            stub_email_verification_request(ADDRESS, KEY, disposable_email_body)
          end

          it "returns true" do
            email = Email.new(ADDRESS, KEY)
            email.disposable.must_equal(true)
          end
        end

        describe "when it is not known if the address is disposable" do
          it "returns nil" do
            email = Email.new(ADDRESS, KEY)
            email.disposable.must_be_nil
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.disposable.must_be_nil
        end
      end
    end

    describe :role_address do
      describe "when the response was successful" do
        describe "when the address is a role address" do
          before do
            stub_email_verification_request(ADDRESS, KEY, role_address_email_body)
          end

          it "returns true" do
            email = Email.new(ADDRESS, KEY)
            email.role_address.must_equal(true)
          end
        end

        describe "when it is not known if the address is a role address" do
          it "returns nil" do
            email = Email.new(ADDRESS, KEY)
            email.role_address.must_be_nil
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.role_address.must_be_nil
        end
      end
    end

    describe :error_code do
      describe "when the response was successful" do
        describe "when the address is valid" do
          it "has no error code" do
            email = Email.new(ADDRESS, KEY)
            email.error_code.must_be_nil
          end
        end

        describe "when the address is not valid" do
          before do
            stub_email_verification_request(ADDRESS, KEY, invalid_email_body)
          end

          it "has an error code" do
            email = Email.new(ADDRESS, KEY)
            email.error_code.must_equal("email_domain_invalid")
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.error_code.must_be_nil
        end
      end
    end

    describe :error do
      describe "when the response was successful" do
        describe "when the address is valid" do
          it "has no error" do
            email = Email.new(ADDRESS, KEY)
            email.error.must_be_nil
          end
        end

        describe "when the address is not valid" do
          before do
            stub_email_verification_request(ADDRESS, KEY, invalid_email_body)
          end

          it "has a more detailed error" do
            email = Email.new(ADDRESS, KEY)
            email.error.must_equal("Email domain invalid")
          end
        end
      end

      describe "when the response was not successful" do
        before do
          stub_error_email_verification_request(ADDRESS, KEY, 500)
        end

        it "returns nil" do
          email = Email.new(ADDRESS, KEY)
          email.error.must_be_nil
        end
      end
    end
  end
end
