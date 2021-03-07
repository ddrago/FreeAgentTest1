module CurrencyExchange

# Return the data given as a dictionary
# Raises an exception if data not found --> In this case where the data comes from a file, exception raised if file not found
def self.get_data()
	#open file and return the data as a dictionary


	return something
end

# Return the exchange rate between from_currency and to_currency on date as a float.
# Raises an exception if unable to calculate requested rate.
# Raises an exception if there is no rate for the date provided.
def self.rate(date, from_currency, to_currency)
	# 1$ = x*1€
	# 1£ = y*1€, therefore:
	# to_currency --> 1£ = y * (1/x) * 1$ <-- from_currency, 
	# exchange rate from $ to £ is y/x


	# TODO: calculate and return rate
end

end