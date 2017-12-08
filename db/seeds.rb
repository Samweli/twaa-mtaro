if ENV["streets"]
  Street.destroy_all

  streets = {}

  streets['hananasifu'] = {street_name: 'hananasifu', ward_name: 'Hananasifu',
                           district: 'Kinondoni', city_name: 'Dar es salaam',
                           coordinates: [-6.799429907878084, 39.265130886060518]}
  streets['mkunguni_a'] = {street_name: 'Mkunguni A', ward_name: 'Hananasifu',
                           district: 'Kinondoni', city_name: 'Dar es salaam',
                           coordinates: [-6.796600784727144, 39.267133521736113]}
  streets['mkunguni_b'] = {street_name: 'Mkunguni B', ward_name: 'Hananasifu',
                           district: 'Kinondoni', city_name: 'Dar es salaam',
                           coordinates: [-6.792270587998448, 39.271825132477105]}
  streets['kisutu'] = {street_name: 'Kisutu', ward_name: 'Hananasifu',
                       district: 'Kinondoni', city_name: 'Dar es salaam',
                       coordinates: [-6.789987652323617, 39.266577246148536]}


  streets.each do |key, street|
    Street.create(
        street_name: street[:street_name],
        ward_name: street[:ward_name],
        municipal_name: street[:district],
        city_name: street[:city_name],
        lat: street[:coordinates][0],
        lng: street[:coordinates][1]
    )
  end
  p "created #{Street.count} streets"
end

if ENV["users"]
# Users
  3.times do |n|
    first_name = Faker::Name.name
    last_name = Faker::Name.name
    email = "example-#{n+1}@twaamtaro.org"
    sms_number = "07123456#{n+1}"
    password = "password"
    User.create!(first_name: first_name,
                 email: email,
                 sms_number: sms_number,
                 last_name: last_name,
                 street_id: 1,
                 password: "password")
  end
  p "created #{User.count} users"
end

if ENV["need_help_categories"]
  # need help categories
  categories = [
      "Vifaa Vinahitajika",
      "Mtaro Unahitaji Marekebisho",
      "Mkandarasi wa kukusanya taka anahitajika",
      "Nyingine"
  ]
  4.times do |key|
    NeedHelpCategory.create(category_name: categories[key])
  end
  p "created #{NeedHelpCategory.count} need help categories"
end

if ENV["roles"]
  # seeding roles
  roles = [

      "citizen",
      "veo",
      "weo",
      "community_member"
  ]
  5.times do |key|
    Role.create(name: roles[key])
  end
  p "created #{Role.count} roles"
end

if ENV["priorities"]
  # seeding priorities
  priorities = [
      "flood prone"
  ]
  1.times do |key|
    Priority.create(name: priorities[key])
  end
  p "created #{Priority.count} priority"
end


