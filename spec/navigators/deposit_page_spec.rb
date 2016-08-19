require 'spec_helper'

describe DepositPage do
  before do
    navigate :login, rut: ENV['RUT'],
                     password: ENV['PASSWORD'],
                     from_account: ENV['SPEC_FROM_ACCOUNT']
  end

  it "should reach the deposit page" do
    navigate
    expect(browser.text)
      .to include("Creación de Transferencia de Fondos de Cuenta Corriente a Cuenta Otros Bancos")
  end
end
