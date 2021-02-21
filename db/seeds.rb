# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if User.count.zero?
  50.times.each do |n|
    User.create!(name: "user-name-#{n + 1}", password: '123456789')
  end
end

if Clock.count.zero?
  100.times.each do |n|
    user = User.all.order("RANDOM()").first
    Clock.create user: user, action: n % 2 + 1
  end
end
