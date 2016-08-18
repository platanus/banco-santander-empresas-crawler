class DepositDeletion < Crabfarm::BaseNavigator
  def run
    navigate :login
    navigate :deposit_authorization_page
    search_trx
    validate_and_select_trx
    browser.search('#botones > input[type="button"]:nth-child(1)').wait(:present).click
    { success: true }
  end

  def validate_and_select_trx
    found = browser.search("#table_1 > tbody > tr").find do |trx|
      amount = trx.search("td")[5].text.strip.delete(".").to_i
      amount == params[:amount].to_i
    end
    found.search("td input").click
    browser.search('#footer > input[type="button"]:nth-child(2)').click
    raise "no se encontro retiro"
  end

  def search_trx
    browser.search("input[name='RUTBENEFICIARIO']").set params[:destinatary_rut]
    browser.search("input[name='CUENTADESTINO']").set params[:destinatary_account]
    browser.search("input[name='GUARDAR']").click
  end
end
