class Login < Crabfarm::BaseNavigator

  def run
    # Add some navigation code here.
    browser.goto "http://www.santander.cl/empresas/index.asp"
    browser.search("input#d_rut").set(params[:rut])
    browser.search("input#d_pin").set(params[:password])
    browser.search("#botonenvio").click()
    reduce_with_defaults
  end

end

