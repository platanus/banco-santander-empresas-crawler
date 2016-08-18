class Login < Crabfarm::BaseNavigator
  def run
    # Add some navigation code here.
    browser.goto "http://www.santander.cl/empresas/index.asp"
    browser.search("input#d_rut").set(params[:rut])
    browser.search("input#d_pin").set(params[:password])
    browser.search("#botonenvio").click

    if browser
       .search("font:contains('Error de autenticación desconocido')").present?
      raise "error de autenticacion"
    end

    select_account unless params[:from_account].blank?
  end

  def select_account
    browser.goto frame: "[name='derecho']"
    found = browser.search("#tablalista > table > tbody > tr").select do |trx|
      trx.search("td")[1].text.to_i == params[:from_account].to_i &&
        trx.search("td")[2].text == "Transaccional"
    end.first
    if found
      found.search("td input").click
      browser.search("#botones > a").click
    else
      raise "cuenta origen no encontrada"
    end
  end
end
