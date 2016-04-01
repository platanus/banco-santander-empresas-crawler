require 'spec_helper'

describe Deposit do

  before do
    navigate :login, rut: ENV['RUT'], password: ENV['PASSWORD']
    navigate :deposit_page
  end

  it "should reach the post deposit page with success" do
    navigate amount: ENV['SPEC_AMOUNT'], destinatary_account: ENV['SPEC_ACCOUNT'], destinatary_bank: ENV['SPEC_BANK'], destinatary_rut: ENV['SPEC_RUT'],destinatary_name: ENV['SPEC_NAME']
    browser.search("a:contains('Transferencias Creadas')").click
    expect(browser.search("#Tcreadas").text).to include(ENV['SPEC_ACCOUNT'].dup.insert(-2, "-"))
  end
end
