require 'json'

module BriteVerify
  class EmailResponse
    SUCCESS_STATUS_CODE = 200
    EMPTY_JSON          = "{}"

    def initialize(response)
      @response = response
    end

    def successful?
      @response.code.to_i == SUCCESS_STATUS_CODE
    end

    def raw_email
      body = successful? ? @response.body : EMPTY_JSON
      JSON.parse(body)
    end
  end
end
