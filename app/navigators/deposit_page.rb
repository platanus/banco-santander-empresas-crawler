class DepositPage < Crabfarm::BaseNavigator

  def run
    # Add some navigation code here.
    browser.goto frame:"[name='izquierdo']"
    browser.search("a:contains('Transferencia entre cuentas')").click
    browser.search("a:contains('Transferencias de Fondo')").click
    browser.search("a:contains('Cuenta corriente a Otros Bancos')").click
    browser.search("a:contains('Creación')").click
    browser.goto frame: :top
    browser.goto frame:"[name='derecho']"
  end

end
