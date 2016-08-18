class Login < Crabfarm::BaseNavigator

  def run
    # Add some navigation code here.
    browser.goto "http://www.santander.cl/empresas/index.asp"
    browser.search("input#d_rut").set(params[:rut])
    browser.search("input#d_pin").set(params[:password])
    browser.search("#botonenvio").click()
    raise "error de autenticacion" if browser.search("font:contains('Error de autenticación desconocido')").present?

    if !params[:from_account].blank?
      puts "FROM ACCOUNT #{params[:from_account]}"
      browser.goto frame:"[name='derecho']"
      browser.search("#tablalista > table > tbody > tr").each do |trx|
        if trx.search("td")[1].text.to_i == params[:from_account].to_i &&
           trx.search("td")[2].text == "Transaccional"
          trx.search("td input").click
          browser.search("#botones > a").click and return
        end
      end
      raise "cuenta origen no encontrada"
    end
  end

end

