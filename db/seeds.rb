if ENV["streets"]

  Municipal.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('municipals')

  municipals = {}

  municipals['kinondoni'] = { municipal_name: 'Kinondoni', city_name: 'Dar es salaam',
                          coordinates: [-6.799429907878084, 39.265130886060518]}


  municipals.each do |key, municipal|
    Municipal.create(
        municipal_name: municipal[:municipal_name],
        city_name: municipal[:city_name],
        lat: municipal[:coordinates][0],
        lng: municipal[:coordinates][1]
    )
  end
  p "created #{Municipal.count} municipals"

  Ward.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('wards')

  wards = {}

  wards['hananasifu'] = { ward_name: 'Hananasifu', municipal_id: 1,
                            coordinates: [-6.799429907878084, 39.265130886060518]}


  wards.each do |key, ward|
    Ward.create(
        ward_name: ward[:ward_name],
        municipal_id: ward[:municipal_id],
        lat: ward[:coordinates][0],
        lng: ward[:coordinates][1]
    )
  end
  p "created #{Ward.count} wards"


  Street.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('streets')

  streets = {}

  streets['hananasifu'] = {street_name: 'hananasifu', ward_id: 1,
                           coordinates: [-6.799429907878084, 39.265130886060518]}
  streets['mkunguni_a'] = {street_name: 'Mkunguni A', ward_id: 1,
                           coordinates: [-6.796600784727144, 39.267133521736113]}
  streets['mkunguni_b'] = {street_name: 'Mkunguni B', ward_id: 1,
                           coordinates: [-6.792270587998448, 39.271825132477105]}
  streets['kisutu'] = {street_name: 'Kisutu', ward_id: 1,
                       coordinates: [-6.789987652323617, 39.266577246148536]}


  streets.each do |key, street|
    Street.create(
        street_name: street[:street_name],
        ward_id: street[:ward_id],
        lat: street[:coordinates][0],
        lng: street[:coordinates][1]
    )
  end
  p "created #{Street.count} streets"
end



if ENV["need_help_categories"]
  # need help categories
  NeedHelpCategory.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('need_help_categories')
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
  Role.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('roles')

  roles = [

      "citizen",
      "veo",
      "weo",
      "meo",
      "community_member"
  ]
  5.times do |key|
    Role.create(name: roles[key])
  end
  p "created #{Role.count} roles"
end

if ENV["priorities"]
  # seeding priorities
  Priority.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('priorities')
  priorities = [
      "flood prone"
  ]
  1.times do |key|
    Priority.create(name: priorities[key])
  end
  p "created #{Priority.count} priority"
end


