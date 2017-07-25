User.destroy_all

10.times do |index|
  User.create(
          first_name: Faker::Name.name,
          last_name: Faker::Name.name,
          sms_number: "0654988047",
          password: "e27702770",
          email: Faker::Internet.email
  )
end

p "created #{User.count} users"