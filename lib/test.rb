require 'json'
require 'date'

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
else #but might be ensure instead
    return exchange_rates
end

def rate(date, from_currency, to_currency)
	#open file and return the data as a dictionary
    date = "2018-09-17" 

    exchange_rates = get_data()
    rate = -1

    if !exchange_rates.nil? #check whether the get_data method managed to retrieve some data. If it didn't, 
        from_er = exchange_rates[date][from_currency]
        to_er = exchange_rates[date][to_currency]
        rate = to_er/from_er    # to_currency --> 1£ = y * (1/x) * 1$ <-- from_currency
    end

    return rate
end

puts rate(Date.new(2018,11,22), "GBP", "AUD")

