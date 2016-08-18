class DepositPage < Crabfarm::BaseNavigator
  # rubocop:disable LineLength
  def run
    browser.goto "https://www.officebanking.cl/Transferencia/OtrosBancos/ObtDiccCreaTrnsf.asp?cod_srv=TRFCTA_CTE_OTROBCO_C"
  end
  # rubocop:enable LineLength
end
