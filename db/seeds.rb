# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Feature.create([{name: 'keyword', has_products: true}, {name: 'clearcart'}, {name: 'safetext'}])
Error.create([{code: 1001, description: 'Server Error', default_message: 'Your {PRICE} order for {ITEM} was unsuccessful due to an internal server error.'},
              {code: 1002, description: 'Product out of stock', default_message: 'Your {PRICE} order for {ITEM} was unsuccessful because the item is out of stock.'},
              {code: 1003, description: 'Insufficient funds', default_message: 'You do not have sufficient funds for your {PRICE} order for {ITEM}.'}])
