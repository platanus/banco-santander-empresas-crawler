require 'spec_helper'

describe BankIdHelper do

  it "should give a valid id for my favourite innovative and open bank" do
    expect(BankIdHelper.get_bank_id('BANCO BCI')).to eq("0016")
    expect(BankIdHelper.get_bank_id('Bice')).to eq("0028")
  end

  it "should not die" do
    expect(BankIdHelper.get_bank_id('BANCO AMOS')).to eq(nil)
  end
end
