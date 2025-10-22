namespace :postman do
  desc 'Generate Postman collection from routes'
  task generate: :environment do
    require 'postman_collection_generator'
    
    collection = PostmanCollectionGenerator::Collection.new(
      name: 'Biblioteca API',
      base_url: 'http://localhost:3000'
    )
    
    # Adicione suas rotas manualmente ou parse do routes.rb
    Rails.application.routes.routes.each do |route|
      next if route.path.spec.to_s.start_with?('/rails')
      next if route.path.spec.to_s.start_with?('/api-docs')
      
      collection.add_request(
        name: "#{route.verb} #{route.path.spec}",
        method: route.verb,
        url: "{{base_url}}#{route.path.spec}",
        description: route.name
      )
    end
    
    File.write('postman_collection.json', collection.to_json)
    puts "✅ Postman collection gerada em postman_collection.json"
  end
end