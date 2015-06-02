# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.create(content: 'This is the testing post, and IT\'S THE FIRST ONE!', post_created: 'Post for the first prophesee.', date_publish: Date.new(2020,1,1))
Post.create(content: 'This is the testing post, Second ONE!', post_created: 'Post for the 2nd prophesee.', date_publish: Date.new(2030,1,1))
Post.create(content: 'I am nobody and that is it.', post_created: 'Nay.', date_publish: Date.new(2040,1,1))

Stock.create(symbol: 'VNET', name: 'good')
Stock.create(symbol: 'AGTK')
Stock.create(symbol: 'AKAM')
Stock.create(symbol: 'BCOR')
Stock.create(symbol: 'BRNW')
Stock.create(symbol: 'CCIH')
Stock.create(symbol: 'CNCN')