class DepositAuthorization < Crabfarm::BaseNavigator

  def run
    navigate :login
    navigate :deposit_authorization_page

    search_trx
    validate_and_select_trx 
    enter_coords

    { success: true }
  end

  def validate_and_select_trx
    browser.search("#table_1 > tbody > tr").each do |trx|
      amount = trx.search("td")[5].text.strip.delete(".").to_i
      if amount == params[:amount].to_i
        trx.search("td")[0].click
        browser.search('#footer > input[type="button"]:nth-child(1)').click and return
      end
    end
    raise "no se encontro retiro"
  end

  def search_trx
    browser.search("input[name='RUTBENEFICIARIO']").set params[:destinatary_rut]
    browser.search("input[name='CUENTADESTINO']").set params[:destinatary_account]
    browser.search("input[name='GUARDAR']").click
  end

  def get_coord_number coord_selector 
    @coords_matrix ||= params[:coords].split(",").collect{|coord| coord.strip}.each_slice(10).to_a
    key_text = browser.search(coord_selector).text
    key_coords = [key_text[0].ord - 65, key_text[1].to_i - 1]
    @coords_matrix[key_coords[1]][key_coords[0]]
  end

  def enter_coords
    browser.search('#clave > input[type="button"]').click

    coord1_selector = '#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(2) > table > tbody > tr:nth-child(1) > td'
    coord2_selector = '#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(4) > table > tbody > tr:nth-child(1) > td'
    coord3_selector = '#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(6) > table > tbody > tr:nth-child(1) > td'
   
    coord1_value = get_coord_number(coord1_selector)
    coord2_value = get_coord_number(coord2_selector)
    coord3_value = get_coord_number(coord3_selector)

    input_coord1_selector = "#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(2) > table > tbody > tr:nth-child(2) > td > input"
    input_coord2_selector = "#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(4) > table > tbody > tr:nth-child(2) > td > input"
    input_coord3_selector = "#Layer1 > table > tbody > tr > td > table > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(6) > table > tbody > tr:nth-child(2) > td > input"

    browser.search(input_coord1_selector).set coord1_value
    browser.search(input_coord2_selector).set coord2_value
    browser.search(input_coord3_selector).set coord3_value

    browser.search('#inputSec > table > tbody > tr > td > input[type="button"]:nth-child(1)').click
  end
end
