require 'twilio-ruby'

class DepositAuthorization < Crabfarm::BaseNavigator
  def run
    navigate :login
    navigate :deposit_authorization_page

    search_trx
    validate_and_select_trx
    enter_coords
    return { success: true } if are_we_there_yet?
    if we_need_to_enter_sms_code?
      puts "Entering code"
      enter_code
    end
    return { success: true } if are_we_there_yet?

    { success: false }
  end

  def validate_and_select_trx
    trx = browser.search("#table_1 > tbody > tr").find do |t|
      amount = t.search("td")[5].text.strip.delete(".").to_i
      status = t.search("td")[8].text.strip
      amount == params[:amount].to_i && status == "Por Autorizar"
    end
    trx.search("td input").click
    browser.search('#footer > input[type="button"]:nth-child(1)').click
    raise "no se encontro retiro"
  end

  def search_trx
    browser.search("input[name='RUTBENEFICIARIO']").set params[:destinatary_rut]
    browser.search("input[name='CUENTADESTINO']").set params[:destinatary_account]
    browser.search("input[name='GUARDAR']").click
  end

  def get_coord_number(key_text)
    @coords_matrix ||= params[:coords].split(",").collect(&:strip).each_slice(10).to_a
    key_coords = [key_text[0].ord - 65, key_text[1].to_i - 1]
    @coords_matrix[key_coords[1]][key_coords[0]]
  end

  # rubocop:disable AbcSize
  # rubocop:disable LineLength
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

    raise "error de coordenadas" if browser.search("font:contains('Los datos ingresados de las coordenadas de su tarjeta son incorrectos')").present?
  end
  # rubocop:enable AbcSize
  # rubocop:enable LineLength

  def enter_code
    browser.search("input[name='CLVOTP3']").set get_code
    browser.search("input[name='btn_ctn']").click
  end

  # rubocop:disable AbcSize
  def get_code
    account_sid = params[:twilio_account_sid]
    auth_token = params[:twilio_auth_token]
    client = Twilio::REST::Client.new account_sid, auth_token
    t = Time.now
    timeout = 10.minutes

    while Time.now < t + timeout
      last_message = client.messages.list(date_sent: t.strftime("%Y-%m-%d")).first
      if last_message && Time.parse(last_message.date_created) > t
        return last_message.body.split(" ")[4].split(".")[0]
      end
      sleep 20.seconds
    end
    raise "Timeout when waiting for SMS"
  end
  # rubocop:enable AbcSize

  def we_need_to_enter_sms_code?
    driver = browser.backend.driver
    all_tabs = driver.window_handles
    if all_tabs.count == 2
      current_tab = driver.window_handle
      driver.switch_to.window (all_tabs - [current_tab]).first
      if browser.search("input[name='CLVOTP3']").present?
        return true
      else
        driver.switch_to.window current_tab
        return false
      end
    end
  end

  def are_we_there_yet?
    driver = browser.backend.driver
    all_tabs = driver.window_handles
    if all_tabs.count == 2
      current_tab = driver.window_handle
      driver.switch_to.window (all_tabs - [current_tab]).first
      if browser.search("body").text["La autorización fue realizada con éxito"].present?
        return true
      else
        driver.switch_to.window current_tab
        return false
      end
    end
  end
end
