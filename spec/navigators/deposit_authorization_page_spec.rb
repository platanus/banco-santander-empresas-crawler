require 'spec_helper'

describe DepositAuthorizationPage do
  before do
    navigate :login, rut: ENV['RUT'],
                     password: ENV['PASSWORD'],
                     from_account: ENV['SPEC_FROM_ACCOUNT']
  end

  it "should reach the deposit authorization page" do
    navigate
    expect(browser.text)
      .to include("Autorización Transferencia de Fondos - Cuenta Corriente a Cuenta Otros Bancos")
  end
end
