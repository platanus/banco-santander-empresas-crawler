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
    browser.search("#table_1 > tbody > tr").each do |trx|
      amount = trx.search("td")[5].text.strip.delete(".").to_i
      if amount == params[:amount].to_i
        trx.search("td input").click 
        browser.search('#footer > input[type="button"]:nth-child(2)').click and return
      end
    end
    raise "no se encontro retiro"
  end

  def search_trx
    browser.search("input[name='RUTBENEFICIARIO']").set params[:destinatary_rut]
    browser.search("input[name='CUENTADESTINO']").set params[:destinatary_account]
    browser.search("input[name='GUARDAR']").click
  end

end
