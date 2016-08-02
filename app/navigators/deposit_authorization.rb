class DepositAuthorization < Crabfarm::BaseNavigator

  def run
    navigate :login
    navigate :deposit_authorization_page

    search_trx
    validate_and_select_trx 
    enter_coords
    enter_code

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

  def enter_code
    browser.search("input[name='CLVOTP3']").set get_code
    browser.search("input[name='btn_ctn']").click
  end
   
  def get_code 
    require 'twilio-ruby'

    account_sid = params[:twilio_account_sid]
    auth_token = params[:twilio_auth_token]

    # set up
    client = Twilio::REST::Client.new account_sid, auth_token
    t = Time.now
    timeout = 10.minutes
    while( Time.now < t + timeout ) do
      puts "Esperando SMS ..."
      last_message = client.messages.list(date_sent:Time.now.strftime("%Y-%m-%d")).first
      time = Time.parse(last_message.date_created)
      if time > t
        puts "Llego mensaje! '#{last_message.body}'"
        # "Su CLAVE 3.0 es 357469.Ingresela en "...
        code = last_message.body.split(" ")[4].split(".")[0]
        puts "Code: #{code}"
        return code
      end
      sleep 20.seconds
    end
  end
end
