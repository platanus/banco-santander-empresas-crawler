class DepositAuthorizationPage < Crabfarm::BaseNavigator

  def run
    browser.goto "https://www.officebanking.cl/Transferencia/otrosBancos/AutorizacionConsultaDetalle.asp?cod_srv=TRFCTA_CTE_OTROBCO_A"
  end
end
