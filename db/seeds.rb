Street.destroy_all

streets = {}

streets['hananasifu'] = { street_name: 'hananasifu', ward_name:'Hananasifu',
                       district: 'Kinondoni', city_name: 'Dar es salaam', 
                       coordinates: [ -6.799429907878084, 39.265130886060518]}
streets['mkunguni_a'] = { street_name: 'Mkunguni A', ward_name:'Hananasifu',
                       district: 'Kinondoni', city_name: 'Dar es salaam', 
                       coordinates: [ -6.796600784727144, 39.267133521736113]}
streets['mkunguni_b'] = { street_name: 'Mkunguni B', ward_name:'Hananasifu',
                       district: 'Kinondoni', city_name: 'Dar es salaam', 
                       coordinates: [ -6.792270587998448, 39.271825132477105]}
streets['kisutu'] = { street_name: 'Kisutu', ward_name:'Hananasifu',
                       district: 'Kinondoni', city_name: 'Dar es salaam', 
                       coordinates: [ -6.789987652323617, 39.266577246148536]}


streets.each do |key, street|
  Street.create(
            street_name: street[:street_name],
            ward_name: street[:ward_name],
            municipal_name: street[:district],
            city_name: street[:street_name],
            lat: street[:coordinates][0],
            lng: street[:coordinates][1]
  )
end

p "created #{Street.count} streets"
