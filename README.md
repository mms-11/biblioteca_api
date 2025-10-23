# 📚 Biblioteca API

![Tests](https://github.com/mms-11/biblioteca_api/actions/workflows/ci.yml/badge.svg)
![Coverage](https://img.shields.io/badge/coverage-86.78%25-brightgreen)

API RESTful para gerenciamento de biblioteca com autenticação JWT, múltiplos tipos de materiais e integração com API externa.

## 🚀 Deploy

**URL da API:** [https://biblioteca-api.onrender.com](sua-url-aqui)

**Documentação Swagger:** [https://biblioteca-api.onrender.com/api-docs](sua-url-aqui/api-docs)

## ✨ Funcionalidades Principais

- ✅ Autenticação JWT (Admin, Bibliotecário, Usuário)
- ✅ CRUD de Materiais (Livros, Revistas, DVDs, etc.)
- ✅ Sistema de Status (disponível, emprestado, reservado)
- ✅ Busca e Paginação
- ✅ Integração com API externa para cadastro
- ✅ Testes com 86.78% de cobertura
- ✅ Documentação Swagger interativa

## 🧪 Testes
```bash
# Rodar todos os testes
bundle exec rspec

# Ver relatório de cobertura
open coverage/index.html
```

**Resultado dos testes:**
- ✅ 48 testes passando
- ✅ 86.78% de cobertura de linha
- ✅ 54.55% de cobertura de branch
```

### 4. **Configurar variáveis de ambiente no Render**

No painel do Render, adicione:
```
RAILS_ENV=production
RACK_ENV=production
SECRET_KEY_BASE=(auto-gerado)
JWT_SECRET=(auto-gerado)
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true