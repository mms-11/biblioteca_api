require 'yaml'
require 'json'

swagger = YAML.load_file('swagger/v1/swagger.yaml')
base_url = 'http://localhost:3000'

collection = {
  info: {
    name: 'Biblioteca API',
    description: 'API para gerenciamento de materiais bibliográficos',
    schema: 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'
  },
  auth: {
    type: 'bearer',
    bearer: [
      {
        key: 'token',
        value: '{{bearer_token}}',
        type: 'string'
      }
    ]
  },
  item: [],
  variable: [
    {
      key: 'base_url',
      value: base_url,
      type: 'string'
    },
    {
      key: 'bearer_token',
      value: '',
      type: 'string'
    }
  ]
}

# Agrupa por tags
folders = {}

swagger['paths'].each do |path, methods|
  methods.each do |method, details|
    next if method == 'parameters'
    
    tag = details['tags']&.first || 'General'
    folders[tag] ||= { name: tag, item: [] }
    
    # Monta a URL
    url_path = path.gsub(/{([^}]+)}/, ':\\1')
    
    request = {
      name: details['summary'] || "#{method.upcase} #{path}",
      request: {
        method: method.upcase,
        header: [],
        url: {
          raw: "{{base_url}}#{url_path}",
          host: ['{{base_url}}'],
          path: url_path.split('/').reject(&:empty?)
        },
        description: details['description']
      }
    }
    
    # Headers
    if details['consumes']&.include?('application/json')
      request[:request][:header] << {
        key: 'Content-Type',
        value: 'application/json',
        type: 'text'
      }
    end
    
    # Auth
    if details['security']
      request[:request][:header] << {
        key: 'Authorization',
        value: 'Bearer {{bearer_token}}',
        type: 'text'
      }
    end
    
    # Query parameters
    if details['parameters']
      query = details['parameters'].select { |p| p['in'] == 'query' }.map do |p|
        {
          key: p['name'],
          value: p['example'] || '',
          description: p['description'],
          disabled: !p['required']
        }
      end
      request[:request][:url][:query] = query if query.any?
    end
    
    # Body
    if ['post', 'patch', 'put'].include?(method)
      if details['parameters']&.any? { |p| p['in'] == 'body' }
        body_param = details['parameters'].find { |p| p['in'] == 'body' }
        if body_param && body_param['schema']
          example = body_param['schema']['example'] || 
                   body_param['schema']['properties']&.transform_values { |v| v['example'] }
          
          request[:request][:body] = {
            mode: 'raw',
            raw: JSON.pretty_generate(example || {}),
            options: {
              raw: {
                language: 'json'
              }
            }
          }
        end
      end
    end
    
    folders[tag][:item] << request
  end
end

collection[:item] = folders.values

File.write('postman_collection.json', JSON.pretty_generate(collection))
puts " Postman collection gerada com sucesso!"
puts " Arquivo: postman_collection.json"
puts ""
puts "Para usar:"
puts "1. Abra o Postman"
puts "2. Clique em 'Import'"
puts "3. Selecione o arquivo 'postman_collection.json'"
puts "4. Configure o bearer_token nas variáveis da collection"