require 'json'
require 'date'

class InputError < StandardError
    def initialize(msg="Faulty input", exception_type="custom")
        @exception_type = exception_type
        super(msg)
    end
end

def get_data()
    error_header_string = "FILE RETRIEVAL ERROR: "
    exchange_rates = {}

    File.open("data/eurofxref-hist-90d.json", "r") do |file| #beginner way to open a file, should look more into this.
        json_file = file.read()
        exchange_rates = JSON.parse(json_file)
    end

rescue Errno::ENOENT, Errno::EACCES, JSON::ParserError => e  
    puts error_header_string + e.to_s
rescue => e
    puts error_header_string + e.to_s
else
    return exchange_rates
end

def rate(date, from_currency, to_currency)
    #TODO problem if one of the currencies is "EUR", since the exchange rates are from euro!
    error_header_string = "DATA RETRIEVAL ERROR: "

	# Get the date in string format. 
    begin 
        date = date.to_s
    rescue Date::Error => e
        puts error_header_string + e.to_s
        return -1
    end

    exchange_rates = get_data()
    rate = -1

    if !exchange_rates.nil? #check whether the get_data method managed to retrieve some data. If it didn't, 
        begin
            from_er = exchange_rates[date][from_currency]
            raise InputError, "from_currency not found" if from_er.nil?
            to_er = exchange_rates[date][to_currency]
            raise InputError, "to_currency not found" if to_er.nil?
            rate = to_er/from_er    # to_currency --> 1£ = y * (1/x) * 1$ <-- from_currency
            
        rescue NoMethodError, TypeError, InputError => e
            puts error_header_string + e.to_s
        end
    end

    return rate
end

puts rate(Date.new(2018,11,22), "GBP", "HUF")

