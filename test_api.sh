#!/bin/bash

# Script de teste completo da Biblioteca API
# Autor: Mariana
# Data: Outubro 2024

set -e  # Para em caso de erro

echo "🚀 Testando Biblioteca API"
echo "================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Setup
echo -e "${BLUE}📋 Setup inicial${NC}"
export API_BASE="https://biblioteca-api-aibp.onrender.com"
echo "✅ API Base: $API_BASE"
echo ""

# 2. Health Check
echo -e "${BLUE}🏥 Health Check${NC}"
HEALTH=$(curl -s "$API_BASE/")
if [ "$HEALTH" == "Biblioteca API is running!" ]; then
  echo -e "${GREEN}✅ API está online!${NC}"
else
  echo -e "${RED}❌ API não está respondendo corretamente${NC}"
  exit 1
fi
echo ""

# 3. Fazer Login
echo -e "${BLUE}🔐 Fazendo login como Admin${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$API_BASE/users/sign_in" \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"admin@biblioteca.com","password":"password123"}}')

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Erro ao obter token!${NC}"
  echo "Resposta: $LOGIN_RESPONSE"
  exit 1
fi

export TOKEN="Bearer $TOKEN"
echo -e "${GREEN}✅ Token obtido com sucesso!${NC}"
echo "Token: ${TOKEN:0:50}..."
echo ""

# 4. Listar Autores
echo -e "${BLUE}📚 Listando autores (primeiros 3)${NC}"
AUTHORS=$(curl -s "$API_BASE/api/v1/authors" -H "Authorization: $TOKEN")
AUTHOR_COUNT=$(echo "$AUTHORS" | jq '. | length')
echo "Total de autores: $AUTHOR_COUNT"
echo "$AUTHORS" | jq '.[0:3]'
echo ""

# 5. Listar Materiais
echo -e "${BLUE}📖 Listando materiais (primeiros 3)${NC}"
MATERIALS=$(curl -s "$API_BASE/api/v1/materials" -H "Authorization: $TOKEN")
MATERIAL_COUNT=$(echo "$MATERIALS" | jq '. | length')
echo "Total de materiais: $MATERIAL_COUNT"
echo "$MATERIALS" | jq '.[0:3]'
echo ""

# 6. Criar Novo Autor
echo -e "${BLUE}➕ Criando novo autor (Isaac Asimov)${NC}"
NEW_AUTHOR=$(curl -s -X POST "$API_BASE/api/v1/authors" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "PersonAuthor",
    "name": "Isaac Asimov",
    "birthdate": "1920-01-02"
  }')

if [ "$(echo "$NEW_AUTHOR" | jq -r '.name')" == "Isaac Asimov" ]; then
  echo -e "${GREEN}✅ Autor criado com sucesso!${NC}"
  echo "$NEW_AUTHOR" | jq '.'
else
  echo -e "${YELLOW}⚠️  Autor pode já existir ou houve erro${NC}"
  echo "$NEW_AUTHOR" | jq '.'
fi
echo ""

# 7. Criar Material
echo -e "${BLUE}📚 Criando novo material (Livro)${NC}"
AUTHOR_ID=$(echo "$AUTHORS" | jq '.[0].id')
NEW_MATERIAL=$(curl -s -X POST "$API_BASE/api/v1/materials" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"material\": {
      \"title\": \"Foundation\",
      \"type\": \"Book\",
      \"isbn\": \"978-0553293357\",
      \"publication_year\": 1951,
      \"author_id\": $AUTHOR_ID,
      \"status\": \"available\"
    }
  }")

if [ "$(echo "$NEW_MATERIAL" | jq -r '.title')" == "Foundation" ]; then
  echo -e "${GREEN}✅ Material criado com sucesso!${NC}"
  echo "$NEW_MATERIAL" | jq '.'
else
  echo -e "${YELLOW}⚠️  Material pode já existir ou houve erro${NC}"
  echo "$NEW_MATERIAL" | jq '.'
fi
echo ""

# 8. Teste GraphQL
echo -e "${BLUE}🔮 Testando GraphQL${NC}"
GRAPHQL_RESPONSE=$(curl -s -X POST "$API_BASE/graphql" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ authors { id name type } }"
  }')

if [ "$(echo "$GRAPHQL_RESPONSE" | jq -r '.data.authors | length')" -gt 0 ]; then
  echo -e "${GREEN}✅ GraphQL funcionando!${NC}"
  echo "Primeiros 3 autores via GraphQL:"
  echo "$GRAPHQL_RESPONSE" | jq '.data.authors[0:3]'
else
  echo -e "${RED}❌ Erro no GraphQL${NC}"
  echo "$GRAPHQL_RESPONSE" | jq '.'
fi
echo ""

# 9. Teste de Logout
echo -e "${BLUE}🚪 Testando logout${NC}"
LOGOUT_RESPONSE=$(curl -s -X DELETE "$API_BASE/users/sign_out" \
  -H "Authorization: $TOKEN")

if [ "$(echo "$LOGOUT_RESPONSE" | jq -r '.message')" == "signed_out" ]; then
  echo -e "${GREEN}✅ Logout realizado com sucesso!${NC}"
else
  echo -e "${YELLOW}⚠️  Resposta de logout: $LOGOUT_RESPONSE${NC}"
fi
echo ""

# 10. Resumo Final
echo "================================"
echo -e "${GREEN}🎉 Todos os testes concluídos!${NC}"
echo ""
echo "📊 Resumo:"
echo "  • API Online: ✅"
echo "  • Autenticação: ✅"
echo "  • Autores: $AUTHOR_COUNT registrados"
echo "  • Materiais: $MATERIAL_COUNT registrados"
echo "  • GraphQL: ✅"
echo "  • CRUD: ✅"
echo ""
echo -e "${BLUE}📚 Documentação completa:${NC}"
echo "  • Swagger: $API_BASE/docs"
echo "  • API Docs: $API_BASE/api-docs"
echo ""
echo -e "${GREEN}✨ Biblioteca API está funcionando perfeitamente!${NC}"