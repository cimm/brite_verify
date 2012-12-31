# BriteVerify

[BriteVerify](http://www.briteverify.com/) is a paying e-mail verification service. You pass it an e-mail address and it tells you if the e-mail address is real or not. They offer a typical REST like API. This gem wraps the API in a more Ruby friendly syntax.

This gem is no way endorsed or certified by BriteVerify. I extracted the code from a project where we are using the BriteVerify e-mail verification service.

## Shortcomings

This gem does not cover all of BriteVerify's services. It only does e-mail verification and does not help you with any of BriteVerify's other services as I did not have a need for any of those so far. Feel free to contribute if you can help, it can only help the Ruby community.

## Installation

Add this line to your application's Gemfile:

    gem 'brite_verify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brite_verify

## Usage

Minimum viable example:

    email = BriteVerify::Email.new("john@example.com", "1298c367-ca34-6e11-3ab5-56027f1d1ec7")
    email.verified?
     => true
    email.status
     => :invalid
    email.account
     => "john"
    email.domain
     => "example.com"
    email.connected
     => nil
    email.disposable
     => false 
    email.role_address
     => false 
    email.duration
     => 0.039381279
    email.error_code
     => "email_domain_invalid"
    email.error
     => "Email domain invalid"

You can skip the API key parameter and specify the `ENV['BRITEVERIFY_API_KEY']` environment variable for convenience.

A more detailed description of the API can be found in the [BriteVerify e-mail documentation](https://github.com/BriteVerify/BriteCode/blob/master/email.md).

## Contributing

Something missing? Found a bug? Horrified by the code? Open a [github issue](https://github.com/cimm/brite_verify/issues), write a failing test or add some code using pull requests. Your help is greatly appreciated!
