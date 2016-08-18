require 'spec_helper'

describe DepositDeletion do
  it "should reach the post deposit deletion page with success" do
    navigate amount: ENV['SPEC_AMOUNT'],
             destinatary_account: ENV['SPEC_ACCOUNT'],
             destinatary_bank: ENV['SPEC_BANK'],
             destinatary_rut: ENV['SPEC_RUT'],
             destinatary_name: ENV['SPEC_NAME'],
             rut: ENV['RUT'],
             password: ENV['PASSWORD'],
             from_account: ENV['SPEC_FROM_ACCOUNT'],
             coords: ENV['SPEC_COORDS']
    expect(browser.search("#estatusproceso").wait(:present).text)
      .to include("Fueron eliminados satisfactoriamente los siguientes registros")
  end
end
