# FreeAgent Coding Challenge

## Requirements
require 'json'
require 'date'

## Your Solution Setup and Run Instructions

Minimimum setup is required. To have access to the methods, just have "require 'currency_exchange' " on top of the code where these methods are needed (just like it is done in currency_exchange_test.rb). 

Instructions: 
    to use the method 'rate', the developer must provide the parametres for a Date object (the date of the required exchange rate), a from_currency string and a to_currency string, both formatted as a three letter string.  


## Your Design Decisions

# get_data() method

I went for a get data method. This allows the developer more flexibility, in case they want to change the source of the data. 
By promoting the separation of concerns, this design choice saves maintenence time and effort. 

Exception handlign is in place for errors relating to the data file and those relating to the parsing of the JSON file. 
If a specific exception isn't caught, rescue a general exception and print the traceback and the message. More details on this same 
design strategy in the "# rate() method" section. 

The constant variable "EUR" allows the user to more flexibily change the currency of reference depending on the database


# rate() method

The from_currency and to_currency strings are manually capitalized to prevent potential input errors.

A custom Exception class handles input errors like wrong date, from_currency or to_currency given. 
This accompanies all the other exception handling, which uses standard classes. 

To cover all possible cases, I tended to raise specific Exceptions when possible, and cast a general exception handling
(see lines like "rescue => e") to catch whatever exception I might have not thought of. 
This allows for the program to not crash as often during the development process, allowing us to catch and interpret 
general errors like these. This is further aided by the printing, in these exceptional cases, of the backtrace.

In every case an exception occurs, -1.0 (a float so as to prevent possible type errors with an exterior program using these 
methods) is output instead of the exchange rate.

Originally I had an exception handling for retrieving the strong from the Date object, but I couldn't thing of a possible 
exception that wouldn't occur before rather than in the rate() method.

The constant variable "EUR" allows the user to more flexibily change the currency of reference depending on the database

## developer notes

This is the first time I've coded in Ruby, I'm not familiar with the language and some of the solutions I propose might 
be naively implemented. Given the chance of studying the language a bit more, I'd be able to provide a more concise/safe 
solution. 