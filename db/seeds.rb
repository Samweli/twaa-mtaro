Street.destroy_all

coordinates = [[-6.81660, 39.25306], [-6.79342, 39.26711], 
                [-6.80579, 39.24889], [-6.78080, 39.25784],
                [-6.77944, 39.24732]]

5.times do |index|
  Street.create(
            street_name: Faker::Address.street_name,
            ward_name: Faker::Address.street_name,
            municipal_name: Faker::Address.city,
            city_name: Faker::Address.city,
            lat: coordinates[index][0],
            lng: coordinates[index][1]
  )
end

p "created #{Street.count} streets"
