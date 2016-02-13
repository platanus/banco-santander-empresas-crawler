require 'spec_helper'

describe Login do

  it "should go inside private area" do
    navigate(rut:ENV['RUT'],password:ENV['PASSWORD'])
    browser.goto frame:'[name=frame2]'
    expect(browser.search("body").text).to include("Saldos")
  end
end
