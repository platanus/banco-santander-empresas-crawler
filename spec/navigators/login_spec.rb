require 'spec_helper'

describe Login do
  it "should go inside private area" do
    navigate rut: ENV['RUT'],
             password: ENV['PASSWORD'],
             from_account: ENV['SPEC_FROM_ACCOUNT']

    browser.goto frame: "[name='izquierdo']"
    expect(browser.text).to include("Cuentas Corrientes")
  end
end
