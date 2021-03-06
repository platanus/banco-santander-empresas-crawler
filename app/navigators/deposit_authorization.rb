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
        trx.search("td input").click
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

  def get_coord_number key_text 
    @coords_matrix ||= params[:coords].split(",").collect{|coord| coord.strip}.each_slice(10).to_a
    key_coords = [key_text[0].ord - 65, key_text[1].to_i - 1]
    @coords_matrix[key_coords[1]][key_coords[0]]
  end

  def enter_coords
    browser.search('#clave > input[type="button"]').click

    coord1_text = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr > td")[2].text
    coord2_text = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr > td")[5].text
    coord3_text = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr > td")[9].text
   
    coord1_value = get_coord_number(coord1_text)
    coord2_value = get_coord_number(coord2_text)
    coord3_value = get_coord_number(coord3_text)

    input_coord1 = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr input")[0]
    input_coord2 = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr input")[1]
    input_coord3 = browser.search("#Layer1 > table > tbody > tr > td > table > tbody tr")[3].search("td > table > tbody > tr input")[2]

    input_coord1.set coord1_value
    input_coord2.set coord2_value
    input_coord3.set coord3_value

    browser.search('#inputSec > table > tbody > tr > td > input[type="button"]:nth-child(1)').click
  end
end
