# Biblioteca API (Rails 8 · Postgres)

API RESTful para gerenciar uma biblioteca digital com autenticação JWT (Devise + devise-jwt), autorização (Pundit), busca/paginação, consumo da OpenLibrary, GraphQL e documentação Swagger (RSwag).

## Stack
- Ruby 3.3 / Rails 8
- PostgreSQL
- Devise + devise-jwt
- Pundit
- GraphQL (graphql-ruby)
- RSwag (OpenAPI/Swagger)
- RSpec (+ WebMock)

## Setup
```bash
cp .env.example .env 
bin/setup            #  bundle && bin/rails db:setup
bin/dev              # inicia servidor (http://localhost:3000)
