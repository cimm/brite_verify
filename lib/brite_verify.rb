require 'brite_verify/version'
require 'brite_verify/email_fetcher'
require 'brite_verify/email_response'
require 'brite_verify/email'

module BriteVerify
  HOST = "bpi.briteverify.com"

  mattr_accessor(:open_timeout) { 4 }
  mattr_accessor(:read_timeout) { 8 }
end
