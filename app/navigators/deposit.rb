class Deposit < Crabfarm::BaseNavigator

  def run
    navigate :login
    navigate :deposit_page
    browser.search("input[name='MONTO_TEF']").set params[:amount]
    browser.search("input[name='CUENTA_DESTINO_ID']").set params[:destinatary_account]
    browser.search("input[name='NOMBRE_DESTINATARIO']").set params[:destinatary_name]
    browser.search("input[name='RUT_DESTINATARIO']").set params[:destinatary_rut]
    browser.search("select[name='BANCO_DESTINO_ID']").search(value: BankIdHelper.get_bank_id(params[:destinatary_bank]))[:selected] = true
    browser.search("select[name='CUENTA_CARGO_ID']").search(value: "1")[:selected] = true # Cuenta origen
    browser.search("select[name='TIPO_TEF']").search(value: "001")[:selected] = true # En línea
    browser.search("select[name='CONCEPTO_ID']").search(value: "5")[:selected] = true# Concepto asociado
    browser.search("input[name='ACCION']").click
    browser.goto frame: :top
    browser.goto frame:"[name='derecho']"
    browser.search("[name='SubmitConfima']").click
    { success: true }
  end

end
