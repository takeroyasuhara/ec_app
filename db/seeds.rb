# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.create(title: "sampleA", description: "water1", image_url: "XXX", price: 100, stock_quantity: 100)
Product.create(title: "sampleB", description: "book1", image_url: "XXX", price: 500, stock_quantity: 100)
Product.create(title: "sampleC", description: "bag1", image_url: "XXX", price: 5000, stock_quantity: 100)
Product.create(title: "sampleD", description: "water1", image_url: "XXX", price: 120, stock_quantity: 100)
Product.create(title: "sampleE", description: "book2", image_url: "XXX", price: 550, stock_quantity: 100)
Product.create(title: "sampleF", description: "bag2", image_url: "XXX", price: 5500, stock_quantity: 100)
Product.create(title: "sampleG", description: "water3", image_url: "XXX", price: 150, stock_quantity: 100)
Product.create(title: "sampleH", description: "book3", image_url: "XXX", price: 600, stock_quantity: 100)

Address.create(address_text: "nakameguro", user_id: 1)
Address.create(address_text: "sagamiono", user_id: 1)
Address.create(address_text: "kurashiki", user_id: 1)

User.create(name: "takero.yasuhara", email: "takero.yasuhara@litalico.co.jp", password: "litalico", password_confirmation: "litalico")
