class Deposit < Crabfarm::BaseNavigator

  def run
    browser.search("input[name='MONTO_TEF']").set params[:amount]
    browser.search("input[name='CUENTA_DESTINO_ID']").set params[:destinatary_account]
    browser.search("input[name='NOMBRE_DESTINATARIO']").set params[:destinatary_name]
    browser.search("input[name='RUT_DESTINATARIO']").set params[:destinatary_rut]
    browser.search("select[name='BANCO_DESTINO_ID']").set by_value: BankIdHelper.get_bank_id(params[:destinatary_bank])
    browser.search("select[name='CUENTA_CARGO_ID']").set by_value: "1" # Cuenta origen
    browser.search("select[name='TIPO_TEF']").set by_value: "001" # En línea
    browser.search("select[name='CONCEPTO_ID']").set by_value: "5" # Concepto asociado
    browser.search("input[name='ACCION']").click
    browser.goto frame: :top
    browser.goto frame:"[name='derecho']"
    browser.search("[name='SubmitConfima']").click
  end

end
