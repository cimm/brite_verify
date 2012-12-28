module BriteVerify
  class EmailResponse
    def initialize(response)
      @response = response
    end

    def raw_email
      JSON.parse(@response.body)
    end
  end
end
