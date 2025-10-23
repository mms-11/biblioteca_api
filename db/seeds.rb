# db/seeds.rb

puts "🌱 Criando usuários..."

# Admin
admin = User.find_or_create_by!(email: 'admin@biblioteca.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end
puts "✅ Admin criado: #{admin.email}"

# Bibliotecário
bibliotecario = User.find_or_create_by!(email: 'bibliotecario@biblioteca.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end
puts "✅ Bibliotecário criado: #{bibliotecario.email}"

# Usuário
usuario = User.find_or_create_by!(email: 'usuario@biblioteca.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end
puts "✅ Usuário criado: #{usuario.email}"

puts "🎉 Seeds executados com sucesso!"