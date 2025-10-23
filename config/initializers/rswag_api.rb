
Rswag::Api.configure do |c|
  # Caminho onde estão os arquivos swagger YAML/JSON
  c.swagger_root = Rails.root.to_s + '/swagger'

  # (opcional) se quiser personalizar o host dinamicamente
  # c.swagger_filter = lambda { |swagger, env| swagger['host'] = env['HTTP_HOST'] }
end
