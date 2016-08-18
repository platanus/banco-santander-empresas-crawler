class Deposit < Crabfarm::BaseNavigator
  def deposit_exists?
    navigate :login
    navigate :deposit_authorization_page
    search_deposit
    browser.search("#table_1 > tbody > tr").each do |trx|
      amount = trx.search("td")[5].text.strip.delete(".").to_i
      status = trx.search("td")[8].text.strip
      if amount == params[:amount].to_i && status == "Por Autorizar"
        # Then it already exists! so we do nothing.
        return true
      end
    end
    false
  end

  def run
    # We will check first if there is a previous authorization waiting for this deposit request
    return { success: true, existing: true } if deposit_exists?

    navigate :login
    navigate :deposit_page
    create_deposit

    if deposit_exists?
      return { success: true, existing: false }
    else
      return { success: false }
    end
  end

  private

  # rubocop:disable AbcSize
  def create_deposit
    browser.search("input[name='MONTO_TEF']").set params[:amount]
    browser.search("input[name='CUENTA_DESTINO_ID']").set params[:destinatary_account]
    browser.search("input[name='NOMBRE_DESTINATARIO']").set params[:destinatary_name]
    browser.search("input[name='RUT_DESTINATARIO']").set params[:destinatary_rut]
    browser.search("select[name='BANCO_DESTINO_ID']")
           .search(value: BankIdHelper.get_bank_id(params[:destinatary_bank]))[:selected] = true
    browser.search("select[name='CUENTA_CARGO_ID']").search(value: "1")[:selected] = true
    browser.search("select[name='TIPO_TEF']").search(value: "001")[:selected] = true
    browser.search("select[name='CONCEPTO_ID']").search(value: "5")[:selected] = true
    browser.search("input[name='ACCION']").click
    browser.search('body > form > center > input[type="button"]:nth-child(1)').click
  end
  # rubocop:enable AbcSize

  def search_deposit
    browser.search("input[name='RUTBENEFICIARIO']").set params[:destinatary_rut]
    browser.search("input[name='CUENTADESTINO']").set params[:destinatary_account]
    browser.search("input[name='GUARDAR']").click
  end
end
