# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.create(title: "sampleA", description: "water", image_url: "XXX", price: 100, stock_quantity: 5)
Product.create(title: "sampleB", description: "book", image_url: "XXX", price: 500, stock_quantity: 5)
Product.create(title: "sampleC", description: "bag", image_url: "XXX", price: 5000, stock_quantity: 100)

Address.create(address_text: "nakameguro", user_id: 1)
Address.create(address_text: "sagamiono", user_id: 1)
Address.create(address_text: "kurashiki", user_id: 1)
