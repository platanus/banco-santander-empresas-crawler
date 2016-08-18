require 'spec_helper'

describe DepositAuthorization do
  it "should reach the post deposit page with success" do
    navigate amount: ENV['SPEC_AMOUNT'],
             destinatary_account: ENV['SPEC_ACCOUNT'],
             destinatary_bank: ENV['SPEC_BANK'],
             destinatary_rut: ENV['SPEC_RUT'],
             destinatary_name: ENV['SPEC_NAME'],
             rut: ENV['RUT'],
             password: ENV['PASSWORD'],
             from_account: ENV['SPEC_FROM_ACCOUNT'],
             twilio_account_sid: ENV["TWILIO_ACCOUNT_SID"],
             twilio_auth_token: ENV["TWILIO_AUTH_TOKEN"],
             coords: ENV['SPEC_COORDS']
    expect(browser.search("#estatusproceso").wait(:present).text).to_not include("error")
  end
end
