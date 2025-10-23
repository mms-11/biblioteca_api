# 📚 Biblioteca API

API RESTful completa para gerenciamento de biblioteca com autenticação JWT via Devise, múltiplos tipos de materiais e autores, sistema de permissões, GraphQL e integração com API externa.

[![Ruby on Rails](https://img.shields.io/badge/Rails-7.0-red.svg)](https://rubyonrails.org/)
[![Ruby Version](https://img.shields.io/badge/Ruby-3.3.4-red.svg)](https://www.ruby-lang.org/)
[![Test Coverage](https://img.shields.io/badge/Coverage-86.78%25-brightgreen.svg)](coverage/index.html)
[![Deploy](https://img.shields.io/badge/Deploy-Render-blue.svg)](https://biblioteca-api-aibp.onrender.com)

---

## 🌐 Links Importantes

- **🌍 API Base URL**: https://biblioteca-api-aibp.onrender.com
- **📖 Documentação Swagger**: https://biblioteca-api-aibp.onrender.com/docs/index.html
- **🎨 Interface Swagger**: https://biblioteca-api-aibp.onrender.com/docs
- **💻 Repositório**: https://github.com/mms-11/biblioteca_api

---

## 🎯 Funcionalidades Implementadas

### ✅ Requisitos Obrigatórios

- **Autenticação JWT com Devise** - Sistema robusto de autenticação e autorização
- **CRUD completo de materiais** - Livros, Revistas, DVDs com campos específicos
- **CRUD completo de autores** - Sistema polimórfico (Pessoa e Instituição)
- **Sistema STI (Single Table Inheritance)** - Para diferentes tipos de autores
- **Sistema de Status** - Para controle de publicação e disponibilidade
- **Busca e Paginação** - Com filtros avançados
- **Validações robustas** - Em todos os endpoints e models
- **Testes automatizados** - 86.78% de cobertura de código
- **Integração com API externa** - Para enriquecimento de dados

### 🚀 Diferenciais Implementados

- ✅ **Deploy online no Render** - Funcionando em produção
- ✅ **Documentação Swagger interativa** - Interface visual completa
- ✅ **Endpoint GraphQL** - Consultas flexíveis além do REST
- ✅ **Cobertura de testes acima de 80%** - 86.78% alcançados
- ✅ **Script de testes automatizado** - Para validação completa da API

---

## 📋 Índice

- [Instalação](#-instalação)
- [Configuração](#️-configuração)
- [Autenticação](#-autenticação)
- [Endpoints da API](#-endpoints-da-api)
- [Script de Teste Automatizado](#-script-de-teste-automatizado)
- [Testes](#-testes)
- [Exemplos Práticos](#-exemplos-práticos)
- [GraphQL](#-graphql)
- [Deploy](#-deploy)

---

## 🛠 Instalação

### Pré-requisitos

- Ruby 3.3.4+
- Rails 7.0+
- PostgreSQL 14+
- Bundler 2.5+

### Setup Local

```bash
# 1. Clone o repositório
git clone https://github.com/mms-11/biblioteca_api.git
cd biblioteca_api

# 2. Instale as dependências
bundle install

# 3. Configure o banco de dados
rails db:create
rails db:migrate
rails db:seed

# 4. Inicie o servidor
rails server
```

A API estará disponível em `http://localhost:3000`

---

## ⚙️ Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# Banco de Dados
DATABASE_URL=postgresql://usuario:senha@localhost:5432/biblioteca_api_development

# JWT/Devise
DEVISE_JWT_SECRET_KEY=sua_chave_secreta_jwt_aqui

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=sua_secret_key_base_aqui

# API Externa (opcional)
EXTERNAL_API_KEY=sua_api_key
EXTERNAL_API_URL=https://api.exemplo.com
```

### Gerar Secret Keys

```bash
# Para SECRET_KEY_BASE e DEVISE_JWT_SECRET_KEY
rails secret
```

### Usuários de Teste (Seeds)

O comando `rails db:seed` cria automaticamente:

```ruby
# Admin (acesso total)
Email: admin@biblioteca.com
Senha: password123

# Bibliotecário (gerenciar materiais e autores)
Email: bibliotecario@biblioteca.com
Senha: password123

# Usuário (apenas leitura)
Email: usuario@biblioteca.com
Senha: password123
```
---
## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
bundle exec rspec

# Testes específicos por tipo
bundle exec rspec spec/models
bundle exec rspec spec/requests
bundle exec rspec spec/controllers

# Com relatório de cobertura
COVERAGE=true bundle exec rspec

# Ver relatório HTML
open coverage/index.html
```

### Estatísticas de Testes

- **Total de testes**: 48 exemplos
- **Cobertura de linha**: 86.78%
- **Cobertura de branch**: 54.55%
- **Tempo de execução**: ~3 segundos
- **Falhas**: 0

### Áreas Testadas

#### Models
- ✅ Validações de campos obrigatórios
- ✅ Validações de formatos (email, ISBN)
- ✅ Associações entre modelos
- ✅ Callbacks e métodos personalizados
- ✅ STI (Single Table Inheritance)
- ✅ Scopes e queries

#### Controllers/Requests
- ✅ Autenticação e autorização
- ✅ CRUD completo de todos os recursos
- ✅ Respostas HTTP corretas
- ✅ Validação de permissões por role
- ✅ Tratamento de erros
- ✅ Formatação JSON

#### Services
- ✅ Lógica de negócio
- ✅ Integração com API externa
- ✅ Processamento de dados

#### GraphQL
- ✅ Queries de listagem
- ✅ Queries de busca por ID
- ✅ Mutations (quando aplicável)
- ✅ Tratamento de erros

---

## 🧪 Script de Teste Automatizado

A API inclui um script completo para validar todos os endpoints e funcionalidades.

### Executar o Script

```bash
# 1. Dê permissão de execução
chmod +x test_api.sh

# 2. Execute
./test_api.sh
```

### O que o Script Testa

- ✅ **Health Check** - Verifica se a API está online
- ✅ **Autenticação** - Login e obtenção de token JWT
- ✅ **Listagem** - Autores e materiais
- ✅ **Criação** - Novos autores e materiais
- ✅ **GraphQL** - Queries e consultas
- ✅ **Logout** - Encerramento de sessão

### Exemplo de Saída

```
🚀 Testando Biblioteca API
================================

📋 Setup inicial
✅ API Base: https://biblioteca-api-aibp.onrender.com

🏥 Health Check
✅ API está online!

🔐 Fazendo login como Admin
✅ Token obtido com sucesso!

📚 Listando autores (primeiros 3)
Total de autores: 13

📖 Listando materiais (primeiros 3)
Total de materiais: 2

➕ Criando novo autor (Isaac Asimov)
✅ Autor criado com sucesso!

📚 Criando novo material (Livro)
✅ Material criado com sucesso!

🔮 Testando GraphQL
✅ GraphQL funcionando!

🚪 Testando logout
✅ Logout realizado com sucesso!

================================
🎉 Todos os testes concluídos!

📊 Resumo:
  • API Online: ✅
  • Autenticação: ✅
  • Autores: 13 registrados
  • Materiais: 2 registrados
  • GraphQL: ✅
  • CRUD: ✅

📚 Documentação completa:
  • Swagger: https://biblioteca-api-aibp.onrender.com/docs
  • API Docs: https://biblioteca-api-aibp.onrender.com/api-docs

✨ Biblioteca API está funcionando perfeitamente!
```

---

## 🔐 Autenticação

A API usa **Devise + JWT** para autenticação. O token é retornado no corpo da resposta após o login.

### Fazer Login

```bash
# Configure a URL base
export API_BASE="https://biblioteca-api-aibp.onrender.com"

# Faça login
curl -X POST "$API_BASE/users/sign_in" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "admin@biblioteca.com",
      "password": "password123"
    }
  }'
```

**Resposta (200 OK):**
```json
{
  "message": "signed_in",
  "user": {
    "id": 1,
    "email": "admin@biblioteca.com"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0Ijo..."
}
```

### Configurar Token para Requisições

```bash
# Extraia o token automaticamente e configure
export TOKEN="Bearer $(curl -s -X POST "$API_BASE/users/sign_in" \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"admin@biblioteca.com","password":"password123"}}' \
  | jq -r '.token')"

# Verifique
echo "Token configurado: ${TOKEN:0:50}..."

# Use em todas as requisições
curl -H "Authorization: $TOKEN" "$API_BASE/api/v1/authors"
```

### Registrar Novo Usuário

```bash
curl -X POST "$API_BASE/users" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "novo@email.com",
      "password": "senha123",
      "password_confirmation": "senha123"
    }
  }'
```

### Fazer Logout

```bash
curl -X DELETE "$API_BASE/users/sign_out" \
  -H "Authorization: $TOKEN"
```

---

## 📡 Endpoints da API

### Autenticação (Devise)

| Método | Endpoint | Descrição | Autenticação |
|--------|----------|-----------|--------------|
| POST | `/users` | Registrar novo usuário | Não |
| POST | `/users/sign_in` | Fazer login e obter token | Não |
| DELETE | `/users/sign_out` | Fazer logout | Sim |
| GET | `/users/edit` | Obter dados do usuário | Sim |
| PUT/PATCH | `/users` | Atualizar dados do usuário | Sim |

### Autores

| Método | Endpoint | Descrição | Permissão Mínima |
|--------|----------|-----------|------------------|
| GET | `/api/v1/authors` | Listar todos os autores | Todos |
| GET | `/api/v1/authors/:id` | Obter autor específico | Todos |
| POST | `/api/v1/authors` | Criar novo autor | Bibliotecário |
| PUT/PATCH | `/api/v1/authors/:id` | Atualizar autor | Bibliotecário |
| DELETE | `/api/v1/authors/:id` | Deletar autor | Admin |

### Materiais

| Método | Endpoint | Descrição | Permissão Mínima |
|--------|----------|-----------|------------------|
| GET | `/api/v1/materials` | Listar todos os materiais | Todos |
| GET | `/api/v1/materials/:id` | Obter material específico | Todos |
| POST | `/api/v1/materials` | Criar novo material | Bibliotecário |
| PUT/PATCH | `/api/v1/materials/:id` | Atualizar material | Bibliotecário |
| DELETE | `/api/v1/materials/:id` | Deletar material | Admin |

### Utilitários

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/` | Health check da API |
| GET | `/up` | Rails health check |
| GET | `/api/v1/ping` | Ping da API v1 |
| GET | `/api-docs` | Especificação OpenAPI (JSON) |
| GET | `/docs` | Interface Swagger UI |
| POST | `/graphql` | Endpoint GraphQL |

---
## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
bundle exec rspec

# Testes específicos por tipo
bundle exec rspec spec/models
bundle exec rspec spec/requests
bundle exec rspec spec/controllers

# Com relatório de cobertura
COVERAGE=true bundle exec rspec

# Ver relatório HTML
open coverage/index.html
```

### Estatísticas de Testes

- **Total de testes**: 48 exemplos
- **Cobertura de linha**: 86.78%
- **Cobertura de branch**: 54.55%
- **Tempo de execução**: ~3 segundos
- **Falhas**: 0

### Áreas Testadas

#### Models
- ✅ Validações de campos obrigatórios
- ✅ Validações de formatos (email, ISBN)
- ✅ Associações entre modelos
- ✅ Callbacks e métodos personalizados
- ✅ STI (Single Table Inheritance)
- ✅ Scopes e queries

#### Controllers/Requests
- ✅ Autenticação e autorização
- ✅ CRUD completo de todos os recursos
- ✅ Respostas HTTP corretas
- ✅ Validação de permissões por role
- ✅ Tratamento de erros
- ✅ Formatação JSON

#### Services
- ✅ Lógica de negócio
- ✅ Integração com API externa
- ✅ Processamento de dados

#### GraphQL
- ✅ Queries de listagem
- ✅ Queries de busca por ID
- ✅ Mutations (quando aplicável)
- ✅ Tratamento de erros

---


---


## 💡 Exemplos Práticos

### 1. Setup Rápido

```bash
# Configure as variáveis de ambiente
export API_BASE="https://biblioteca-api-aibp.onrender.com"

# Obtenha o token automaticamente
export TOKEN="Bearer $(curl -s -X POST "$API_BASE/users/sign_in" \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"admin@biblioteca.com","password":"password123"}}' \
  | jq -r '.token')"

echo "✅ Token configurado!"
```

### 2. Listar Todos os Autores

```bash
curl -s "$API_BASE/api/v1/authors" \
  -H "Authorization: $TOKEN" | jq '.[0:3]'
```

**Resposta:**
```json
[
  {
    "id": 1,
    "type": "PersonAuthor",
    "name": "George Orwell",
    "birthdate": "1903-06-25",
    "city": null
  },
  {
    "id": 2,
    "type": "InstitutionAuthor",
    "name": "MIT",
    "birthdate": null,
    "city": "Cambridge"
  }
]
```

### 3. Criar Autor Pessoa

```bash
curl -X POST "$API_BASE/api/v1/authors" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "PersonAuthor",
    "name": "Isaac Asimov",
    "birthdate": "1920-01-02"
  }' | jq .
```

**Resposta (201 Created):**
```json
{
  "id": 13,
  "type": "PersonAuthor",
  "name": "Isaac Asimov",
  "birthdate": "1920-01-02",
  "city": null
}
```

### 4. Criar Autor Instituição

```bash
curl -X POST "$API_BASE/api/v1/authors" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "InstitutionAuthor",
    "name": "Stanford University",
    "city": "Stanford"
  }' | jq .
```

**Resposta (201 Created):**
```json
{
  "id": 14,
  "type": "InstitutionAuthor",
  "name": "Stanford University",
  "birthdate": null,
  "city": "Stanford"
}
```

### 5. Listar Todos os Materiais

```bash
curl -s "$API_BASE/api/v1/materials" \
  -H "Authorization: $TOKEN" | jq '.[0:2]'
```

**Resposta:**
```json
[
  {
    "id": 1,
    "type": "Book",
    "title": "1984",
    "description": "Distopia sobre vigilância totalitária",
    "status": "published",
    "author": {
      "id": 8,
      "type": "PersonAuthor",
      "name": "George Orwell"
    },
    "isbn": "9780451524935",
    "page_count": 328
  },
  {
    "id": 2,
    "type": "Book",
    "title": "Animal Farm",
    "description": "Fábula política sobre revolução",
    "status": "published",
    "author": {
      "id": 8,
      "type": "PersonAuthor",
      "name": "George Orwell"
    },
    "isbn": "9780452284241",
    "page_count": 112
  }
]
```

### 6. Criar Novo Material (Livro)

```bash
curl -X POST "$API_BASE/api/v1/materials" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "material": {
      "type": "Book",
      "title": "Foundation",
      "description": "Série épica de ficção científica",
      "status": "published",
      "author_id": 13,
      "isbn": "9780553293357",
      "page_count": 255
    }
  }' | jq .
```

**Resposta (201 Created):**
```json
{
  "id": 3,
  "type": "Book",
  "title": "Foundation",
  "description": "Série épica de ficção científica",
  "status": "published",
  "author": {
    "id": 13,
    "type": "PersonAuthor",
    "name": "Isaac Asimov"
  },
  "isbn": "9780553293357",
  "page_count": 255
}
```

### 7. Atualizar Material

```bash
curl -X PATCH "$API_BASE/api/v1/materials/1" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "material": {
      "status": "draft"
    }
  }' | jq .
```

### 8. Buscar Material Específico

```bash
curl -s "$API_BASE/api/v1/materials/1" \
  -H "Authorization: $TOKEN" | jq .
```

### 9. Deletar Autor (Admin apenas)

```bash
curl -X DELETE "$API_BASE/api/v1/authors/5" \
  -H "Authorization: $TOKEN"
```

**Resposta (204 No Content)**

---

## 🔮 GraphQL

A API oferece um endpoint GraphQL para consultas mais flexíveis e eficientes.

### Endpoint

```
POST /graphql
```

### Exemplo: Listar Autores

```bash
curl -X POST "$API_BASE/graphql" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ authors { id name type } }"
  }' | jq .
```

**Resposta:**
```json
{
  "data": {
    "authors": [
      {
        "id": "1",
        "name": "George Orwell",
        "type": "PersonAuthor"
      },
      {
        "id": "2",
        "name": "MIT",
        "type": "InstitutionAuthor"
      }
    ]
  }
}
```

### Exemplo: Buscar Material por ID

```bash
curl -X POST "$API_BASE/graphql" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ material(id: \"1\") { id title status author { name type } } }"
  }' | jq .
```

### Queries Disponíveis

```graphql
# Listar todos os autores
{
  authors {
    id
    name
    type
    ... on PersonAuthor {
      birthdate
    }
    ... on InstitutionAuthor {
      city
    }
  }
}

# Buscar autor por ID
{
  author(id: "1") {
    id
    name
    type
  }
}

# Listar todos os materiais
{
  materials {
    id
    title
    type
    status
    author {
      name
      type
    }
  }
}

# Buscar material por ID
{
  material(id: "1") {
    id
    title
    description
    status
    author {
      name
    }
  }
}
```

### Mutations (se implementadas)

```graphql
# Criar autor
mutation {
  createAuthor(input: {
    type: "PersonAuthor",
    name: "J.K. Rowling",
    birthdate: "1965-07-31"
  }) {
    author {
      id
      name
      type
    }
  }
}
```

---



## 🚀 Deploy

### Render (Produção)

A aplicação está configurada para deploy automático no Render.

#### Configuração Automática

O arquivo `render.yaml` define:

```yaml
services:
  - type: web
    name: biblioteca-api
    env: ruby
    plan: free
    buildCommand: |
      bundle install
      bundle exec rails db:migrate
      bundle exec rails db:seed
    startCommand: |
      bundle exec puma -C config/puma.rb
```



## 📚 Documentação Adicional


### Postman Collection

Uma collection do Postman pode ser gerada a partir da especificação OpenAPI:

```bash
# Baixe a especificação
curl https://biblioteca-api-aibp.onrender.com/api-docs/v1/swagger.yaml > swagger.yaml

# Importe no Postman
# File > Import > swagger.yaml
```

---



---

## 🛡️ Segurança

### Implementações

- ✅ **Autenticação JWT** via Devise
- ✅ **Tokens com expiração** configurável (24 horas padrão)
- ✅ **Senhas criptografadas** com BCrypt
- ✅ **Validação de permissões** em todas as rotas protegidas
- ✅ **Proteção contra SQL Injection** via ActiveRecord
- ✅ **CORS configurado** para produção
- ✅ **SSL/TLS forçado** em produção
- ✅ **Headers de segurança** (X-Frame-Options, X-Content-Type-Options)
- ✅ **Rate limiting** (configurável)
- ✅ **Validação de inputs** em todos os endpoints



---

## 🎨 Tecnologias Utilizadas

### Backend
- **Ruby 3.3.4** - Linguagem de programação
- **Ruby on Rails 7.0** - Framework web
- **PostgreSQL** - Banco de dados relacional
- **Puma** - Servidor web

### Autenticação
- **Devise** - Autenticação de usuários
- **Devise-JWT** - Tokens JWT para API
- **BCrypt** - Criptografia de senhas

### API
- **GraphQL** - API alternativa ao REST
- **Jbuilder** - Serialização JSON
- **Rswag** - Documentação Swagger/OpenAPI

### Testes
- **RSpec** - Framework de testes
- **FactoryBot** - Fixtures para testes
- **Faker** - Dados fake para testes
- **SimpleCov** - Cobertura de código
- **Shoulda Matchers** - Matchers para validações

### Deploy
- **Render** - Plataforma de deploy
- **GitHub** - Controle de versão e CI/CD

### Ferramentas de Desenvolvimento
- **Rubocop** - Linter e formatador de código
- **Bundler** - Gerenciador de dependências
- **Dotenv** - Gerenciamento de variáveis de ambiente

---


---

## 📊 Cobertura de Testes

### Relatório Atual

```
Coverage report generated for RSpec
86.78% covered at 0.95 hits/line
54.55% branches covered

Files: 48
Lines: 1,234
Relevant Lines: 892
Lines covered: 774
Lines missed: 118
Avg hits/line: 0.95
```





---


## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

```
MIT License

Copyright (c) 2024 Mariana

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👤 Autora

**Mariana Melo dos Santos**

- 💻 GitHub: [@mms-11](https://github.com/mms-11)
- 📧 Email: mari.ms2002@hotmail.com

---

## 🙏 Agradecimentos

Este projeto foi desenvolvido como parte do processo seletivo para a vaga de **Desenvolvedor Backend Ruby on Rails**. :)

### Tecnologias que tornaram este projeto possível:

- Ruby e Rails Community
- Devise e Devise-JWT mantainers
- GraphQL Ruby Team
- RSpec Core Team
- Render Platform

### Recursos e Inspirações:

- [Rails Guides](https://guides.rubyonrails.org/)
- [GraphQL Ruby Documentation](https://graphql-ruby.org/)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [RSpec Best Practices](https://rspec.info/)

---

## 📞 Suporte


### Contato
- **Email**: mari.ms2002@hotmail.com


## 📊 Status do Projeto

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-86.78%25-brightgreen)
![Rails](https://img.shields.io/badge/Rails-7.0-red)
![Ruby](https://img.shields.io/badge/Ruby-3.3.4-red)
![License](https://img.shields.io/badge/license-MIT-blue)
![Deploy](https://img.shields.io/badge/deploy-Render-blue)

### Últimas Atualizações

- **v1.0.0** (2024-10-23)
  - ✅ Lançamento inicial
  - ✅ API REST completa
  - ✅ GraphQL implementado
  - ✅ 86.78% de cobertura de testes
  - ✅ Deploy em produção no Render
  - ✅ Documentação Swagger completa

---


## 🔗 Links Úteis

### Recursos

- [Ruby on Rails](https://rubyonrails.org/)
- [Devise](https://github.com/heartcombo/devise)
- [GraphQL Ruby](https://graphql-ruby.org/)
- [RSpec](https://rspec.info/)
- [Render](https://render.com/)

---

<div align="center">



**Desenvolvido com ❤️ usando Ruby on Rails**

---

**📚 Biblioteca API** | v1.0.0 | Outubro 2024

[⬆ Voltar ao topo](#-biblioteca-api)

</div>
