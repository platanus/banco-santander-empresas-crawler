class DepositPage < Crabfarm::BaseNavigator

  def run
    browser.goto "https://www.officebanking.cl/Transferencia/OtrosBancos/ObtDiccCreaTrnsf.asp?cod_srv=TRFCTA_CTE_OTROBCO_C"
  end
end
