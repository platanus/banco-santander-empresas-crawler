require 'spec_helper'

describe Deposit do
  it "should reach the post deposit page with success" do
    navigate amount: ENV['SPEC_AMOUNT'],
             destinatary_account: ENV['SPEC_ACCOUNT'],
             destinatary_bank: ENV['SPEC_BANK'],
             destinatary_rut: ENV['SPEC_RUT'],
             destinatary_name: ENV['SPEC_NAME'],
             rut: ENV['RUT'],
             password: ENV['PASSWORD'],
             from_account: ENV['SPEC_FROM_ACCOUNT']
    expect(browser
           .search("#table_1 > tbody > tr > td:nth-child(3)")
           .text
           .delete("- ")).to include(ENV['SPEC_ACCOUNT'].delete("- "))
  end
end
