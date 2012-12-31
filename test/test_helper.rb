require 'minitest/spec'
require 'minitest/mock'
require 'minitest/autorun'
require 'webmock/minitest'
require 'brite_verify'

FIXTURES_PATH = File.expand_path("#{File.dirname(__FILE__)}/fixtures")

def valid_email_body
  @valid_email_body ||= File.read(File.join(FIXTURES_PATH, 'valid_email.json'))
end

def invalid_email_body
  @invalid_email_body ||= File.read(File.join(FIXTURES_PATH, 'invalid_email.json'))
end

def unknown_email_body
  @unknown_email_body ||= File.read(File.join(FIXTURES_PATH, 'unknown_email.json'))
end

def accept_all_email_body
  @accept_all_email_body ||= File.read(File.join(FIXTURES_PATH, 'accept_all_email.json'))
end

def connected_email_body
  @connected_email_body ||= File.read(File.join(FIXTURES_PATH, 'connected_email.json'))
end

def disposable_email_body
  @disposable_email_body ||= File.read(File.join(FIXTURES_PATH, 'disposable_email.json'))
end

def role_address_email_body
  @role_address_email_body ||= File.read(File.join(FIXTURES_PATH, 'role_address_email.json'))
end

def stub_email_verification_request(address, key, body)
  request          = { :headers => {'Accept' => '*/*', 'User-Agent' => 'Ruby'} }
  response         = { :status => 200, :body => body, :headers => {} }
  stub_request(:get, email_verification_url(address, key)).with(request).to_return(response)
end

def stub_error_email_verification_request(address, key, code)
  status           = []
  verification_url = email_verification_url(address, key)
  case code
  when 500 then status = [500, "Internal Server Error"]
  end
  stub_request(:get, verification_url).to_return(:status => status)
end

def email_verification_url(address, key)
  "https://bpi.briteverify.com/emails.json?address=#{address}&apikey=#{key}"
end
