require 'json'
require 'date'

module CurrencyExchange

	CURRENCY_OF_REFERENCE = "EUR"
	DATA_FILEPATH = "data/eurofxref-hist-90d.json"

	class InputError < StandardError
		def initialize(msg="Faulty input", exception_type="custom")
			@exception_type = exception_type
			super(msg)
		end
	end

	# Return the data given as a dictionary
	# Raises an exception if data not found --> In this case where the data comes from a file, exception raised if file not found 
	# or if it is not parsed correctly
	def self.get_data()
		error_header_string = "FILE RETRIEVAL ERROR: "
		exchange_rates = {}
	
		File.open(DATA_FILEPATH, "r") do |file|
			json_file = file.read()
			exchange_rates = JSON.parse(json_file)
		end
	
	rescue Errno::ENOENT, Errno::EACCES, JSON::ParserError => e  
		puts error_header_string + e.to_s
	rescue => e
		puts error_header_string + e.to_s
		puts e.backtrace.inspect
	else
		return exchange_rates
	end
	

	# Return the exchange rate between from_currency and to_currency on date as a float.
	# Raises an exception if unable to calculate requested rate.
	# Raises an exception if there is no rate for the date provided.
	def self.rate(date, from_currency, to_currency)
		error_header_string = "DATA RETRIEVAL ERROR: "

		# Get the date in string format. Get the input capitalized as needed by the dataset
		date = date.to_s
		from_currency = from_currency.upcase
		to_currency = to_currency.upcase
	
		exchange_rates = get_data()
		rate = -1.0  #default return in case some error occurs. 
	
		if !exchange_rates.nil? #check whether the get_data method managed to retrieve some data. If it didn't, 
			begin
				if from_currency == CURRENCY_OF_REFERENCE
					rate = exchange_rates[date][to_currency]
					raise InputError, "date not found" if exchange_rates[date].nil?
					raise InputError, "to_currency not found" if rate.nil?
				elsif to_currency == CURRENCY_OF_REFERENCE
					rate = 1/exchange_rates[date][from_currency]
					raise InputError, "date not found" if exchange_rates[date].nil?
					raise InputError, "from_currency not found" if rate.nil?
				else
					# 1$ = x*1€
					# 1£ = y*1€, therefore:
					# to_currency --> 1£ = y * (1/x) * 1$ <-- from_currency, 
					# exchange rate from $ to £ is y/x
					from_er = exchange_rates[date][from_currency]
					raise InputError, "date not found" if exchange_rates[date].nil?
					raise InputError, "from_currency not found" if from_er.nil?
					to_er = exchange_rates[date][to_currency]
					raise InputError, "to_currency not found" if to_er.nil?
					rate = to_er/from_er 
				end
				
			rescue NoMethodError, TypeError, InputError => e
				puts error_header_string + e.to_s
			rescue => e
				puts error_header_string + e.to_s
				puts e.backtrace.inspect
			end
		else
			puts "No data was retrieved"
		end
	
		return rate
	end

end