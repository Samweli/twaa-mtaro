Street.destroy_all

5.times do |index|
  Street.create(
            street_name: Faker::Address.street_name,
            ward_name: Faker::Address.street_name,
            municipal_name: Faker::Address.city,
            city_name: Faker::Address.city
  )
end

p "created #{Street.count} streets"
