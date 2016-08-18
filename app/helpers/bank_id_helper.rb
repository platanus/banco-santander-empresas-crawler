module BankIdHelper
  extend self

  BANKS = {
    "de chile": "0001",
    "internacional": "0009",
    "del estado de chile": "0012",
    "del estado": "0012",
    "scotiabank chile": "0014",
    "scotiabank": "0014",
    "de credito e inversiones": "0016",
    "bci": "0016",
    "corpbanca": "0027",
    "bice": "0028",
    "hsbc bank (chile)": "0031",
    "hsbc": "0031",
    "itaú chile": "0039",
    "itaú": "0039",
    "itau": "0039",
    "security": "0049",
    "falabella": "0051",
    "ripley": "0053",
    "rabobank chile": "0054",
    "rabobank": "0054",
    "consorcio": "0055",
    "paris": "0057",
    "bilbao vizcaya argentaria, chile": "0504",
    "bbva": "0504",
    "del desarrollo": "0507",
    "coopeuch": "0672"
  }

  def get_bank_id(_name)
    _name = clean_name(_name)
    keys = BANKS.keys.select{|key| _name[key.to_s] }
    raise "found more than 1 bank with similar name! #{_name}" if keys.count > 1
    BANKS[keys.first]
  end

  def clean_name(name)
    name.downcase.gsub(/banco\s/,"")
      .gsub("Á","a")
      .gsub("É","e")
      .gsub("Í","i")
      .gsub("Ó","o")
      .gsub("Ú","u")
  end
end
