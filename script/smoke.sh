#!/usr/bin/env bash
set -euo pipefail

API_BASE="https://biblioteca-api-aibp.onrender.com"

echo "🚀 Smoke tests — Biblioteca API"

# ---------- login ----------
echo "z Login..."
TOKEN=$(
  curl -fsS -X POST "$API_BASE/users/sign_in" \
    -H "Content-Type: application/json" \
    -d '{"user":{"email":"SEU_EMAIL","password":"SUA_SENHA"}}' \
  | jq -r '.token // .jwt // .access_token'
)
[[ -z "${TOKEN:-}" ]] && { echo "❌ Sem token"; exit 1; }
AUTH=(-H "Authorization: Bearer $TOKEN")
echo "✅ Token OK"

# helpers
find_author_id() {
  local name="$1"
  curl -fsS "$API_BASE/api/v1/authors" "${AUTH[@]}" \
  | jq -r --arg n "$name" '.[] | select(.name==$n) | .id' | head -n1
}

create_author_if_missing() {
  local type="$1" name="$2" city="${3:-null}" birthdate="${4:-null}"
  local id
  id=$(find_author_id "$name" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  curl -fsS -X POST "$API_BASE/api/v1/authors" "${AUTH[@]}" \
    -H "Content-Type: application/json" \
    -d @- <<JSON | jq -r '.id'
{ "author": { "type": "$type", "name": "$name", "city": ${city:-null}, "birthdate": ${birthdate:-null} } }
JSON
}

find_material_id() {
  local title="$1"
  curl -fsS "$API_BASE/api/v1/materials?q=$(
    python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$title"
  )" "${AUTH[@]}" | jq -r --arg t "$title" '.[] | select(.title==$t) | .id' | head -n1
}

create_book_if_missing() {
  local title="$1" desc="$2" author_id="$3" isbn="$4" pages="$5"
  local id
  id=$(find_material_id "$title" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  curl -fsS -X POST "$API_BASE/api/v1/materials" "${AUTH[@]}" \
    -H "Content-Type: application/json" \
    -d @- <<JSON | jq -r '.id'
{ "material": { "type": "Book", "title": "$title", "description": "$desc",
  "status": "published", "author_id": $author_id, "isbn": "$isbn", "page_count": $pages } }
JSON
}

# ---------- autores ----------
echo "👤 Autores..."
ORWELL_ID=$(create_author_if_missing "PersonAuthor" "George Orwell" "null" '"1903-06-25"')
MIT_ID=$(create_author_if_missing "InstitutionAuthor" "Massachusetts Institute of Technology" '"Cambridge"' "null")
echo "✅ Orwell: $ORWELL_ID | MIT: $MIT_ID"

# ---------- materiais ----------
echo "📚 Materiais..."
B1984_ID=$(create_book_if_missing "1984" "Distopia sobre vigilância totalitária" "$ORWELL_ID" "9780451524935" 328)
AFARM_ID=$(create_book_if_missing "Animal Farm" "Fábula política sobre revolução" "$ORWELL_ID" "9780452284241" 112)
echo "✅ Livros: $B1984_ID, $AFARM_ID"

# ---------- buscas ----------
echo "🔎 Busca 1984:"
curl -fsS "$API_BASE/api/v1/materials?q=1984" "${AUTH[@]}" | jq .
echo "🔎 Busca MIT:"
curl -fsS "$API_BASE/api/v1/materials?q=MIT" "${AUTH[@]}" | jq .

# ---------- autores ----------
echo "👥 Autores:"
curl -fsS "$API_BASE/api/v1/authors" "${AUTH[@]}" | jq '.[0:10]'

# ---------- ping ----------
echo "🏓 Ping:"
curl -fsS "$API_BASE/api/v1/ping" "${AUTH[@]}" | jq .

echo "✅ Smoke OK!"
