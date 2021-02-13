require File.expand_path("#{File.dirname(__FILE__)}/test_helper")
require 'json'

module BriteVerify
  describe EmailResponse do
    before do
      @response = Net::HTTPResponse.new(1.0, 200, "OK")
    end

    describe :successful? do
      describe "when it succeeded" do
        it "returns true" do
          email_response = EmailResponse.new(@response)
          _(email_response.successful?).must_equal(true)
        end
      end

      describe "when something went wrong" do
        before do
          @response = Net::HTTPResponse.new(1.0, 500, "Internal Server Error")
        end

        it "returns false" do
          email_response = EmailResponse.new(@response)
          _(email_response.successful?).must_equal(false)
        end
      end
    end

    describe :raw_email do
      describe "when it succeeded" do
        before do
          @response = MiniTest::Mock.new # can't set response.body for some reason
          @response.expect(:code, "200")
          @response.expect(:body, valid_email_body)
        end

        it "returns the raw email" do
          email_response          = EmailResponse.new(@response)
          parsed_valid_email_body = JSON.parse(valid_email_body)
          _(email_response.raw_email).must_equal(parsed_valid_email_body)
        end
      end

      describe "when something went wrong" do
        before do
          @response = Net::HTTPResponse.new(1.0, 500, "Internal Server Error")
        end

        it "returns an empty raw email" do
          email_response = EmailResponse.new(@response)
          _(email_response.raw_email).must_equal({})
        end
      end
    end
  end
end
