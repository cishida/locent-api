# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Feature.create([{name: 'Keyword', has_products: true}, {name: 'Clearcart'}, {name: 'Safetext'}])
Error.create([{code: 1001, description: 'Server Error'}, {code: 1002, description: 'Product out of stock'}, {code: 1003, description: 'Insufficient funds'}])
