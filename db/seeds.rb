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

# Users
User.create!(first_name:  "Example",
             last_name: "User",
             sms_number: "071234567890",
             street_id: 1,
             email: "example@twaamtaro.org",
             password:              "password")
99.times do |n|
  first_name = Faker::Name.name
  last_name = Faker::Name.name
  email = "example-#{n+1}@twaamtaro.org"
  sms_number = "07123456#{n+1}"
  password = "password"
  User.create!(first_name:  first_name,
               email: email,
               sms_number: sms_number,
               last_name: last_name,
               street_id: 1,
               password: "password")
end

p "created #{Street.count} streets"
p "created #{User.count} users"
