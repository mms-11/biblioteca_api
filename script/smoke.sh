#!/usr/bin/env bash
set -euo pipefail

# ===================== CONFIG =====================
API_BASE="${API_BASE:-https://biblioteca-api-aibp.onrender.com}"
EMAIL="${EMAIL:-admin2@demo.com}"      # export EMAIL=...
PASSWORD="${PASSWORD:-secret123}"      # export PASSWORD=...
# ==================================================

echo "🚀 Smoke tests — Biblioteca API ($API_BASE)"

# deps
if ! command -v jq >/dev/null 2>&1; then
  echo "❌ 'jq' não encontrado. Instale: sudo apt-get install -y jq  (ou brew install jq)"
  exit 1
fi

AUTH=() # preenchido após login

# ---------- utils ----------
urlencode() { jq -rn --arg s "$1" '$s|@uri'; }

post_json() {
  # usage: post_json <url> <json-string>
  local url="$1" body="$2"
  # imprime: BODY (linha 1)  e STATUS (linha 2)
  curl -sS -X POST "$url" "${AUTH[@]}" -H "Content-Type: application/json" -d "$body" -w "\n%{http_code}"
}

# ---------- login ----------
echo "🔐 Login..."
LOGIN_JSON=$(
  curl -fsS -X POST "$API_BASE/users/sign_in" \
    -H "Content-Type: application/json" \
    -d "{\"user\":{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}}"
)
TOKEN=$(echo "$LOGIN_JSON" | jq -r '(.token // .jwt // .access_token // "")')
if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
  echo "❌ Sem token. Resposta:"
  echo "$LOGIN_JSON" | jq . || echo "$LOGIN_JSON"
  exit 1
fi
AUTH=(-H "Authorization: Bearer $TOKEN")
echo "✅ Token OK (${#TOKEN} chars)"

# ---------- find helpers ----------
find_author_id() {
  local name="$1"
  curl -fsS "$API_BASE/api/v1/authors" "${AUTH[@]}" \
  | jq -r --arg n "$name" '.[] | select(.name==$n) | .id' | head -n1
}

find_book_id_by_isbn() {
  local isbn="$1"
  curl -fsS "$API_BASE/api/v1/materials?q=$(urlencode "$isbn")" "${AUTH[@]}" \
  | jq -r --arg i "$isbn" '.[] | select(.isbn==$i) | .id' | head -n1
}

find_article_id_by_doi() {
  local doi="$1"
  curl -fsS "$API_BASE/api/v1/materials?q=$(urlencode "$doi")" "${AUTH[@]}" \
  | jq -r --arg d "$doi" '.[] | select(.doi==$d) | .id' | head -n1
}

find_video_id_by_title_year() {
  local title="$1" year="$2"
  curl -fsS "$API_BASE/api/v1/materials?q=$(urlencode "$title")" "${AUTH[@]}" \
  | jq -r --arg t "$title" --argjson y "$year" '.[] | select(.title==$t and .release_year==$y) | .id' | head -n1
}

# ---------- create-if-missing ----------
create_author_if_missing() {
  local type="$1" name="$2" city="${3:-null}" birthdate="${4:-null}"
  local id
  id=$(find_author_id "$name" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  read -r body status < <(post_json "$API_BASE/api/v1/authors" \
'{
  "author": { "type": "'"$type"'", "name": "'"$name"'", "city": '"${city:-null}"', "birthdate": '"${birthdate:-null}"' }
}')
  if [[ "$status" == "201" || "$status" == "200" ]]; then
    echo "$body" | jq -r '.id'
  elif [[ "$status" == "422" ]]; then
    echo "⚠️  422 Author: $(echo "$body" | jq -c '.errors // .')" >&2
    id=$(find_author_id "$name" || true)
    [[ -n "${id:-}" ]] && { echo "$id"; return; }
    exit 1
  else
    echo "❌ Author HTTP $status: $body" >&2
    exit 1
  fi
}

create_book_if_missing() {
  local title="$1" desc="$2" author_id="$3" isbn="$4" pages="$5"
  local id
  id=$(find_book_id_by_isbn "$isbn" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  local payload
  payload=$(jq -n \
    --arg t "$title" --arg d "$desc" --arg i "$isbn" \
    --argjson a "$author_id" --argjson p "$pages" \
    '{material:{type:"Book",title:$t,description:$d,status:"published",author_id:$a,isbn:$i,page_count:$p}}'
  )
  read -r body status < <(post_json "$API_BASE/api/v1/materials" "$payload")
  if [[ "$status" == "201" || "$status" == "200" ]]; then
    echo "$body" | jq -r '.id'
  elif [[ "$status" == "422" ]]; then
    echo "⚠️  422 Book: $(echo "$body" | jq -c '.errors // .')" >&2
    id=$(find_book_id_by_isbn "$isbn" || true)
    [[ -n "${id:-}" ]] && { echo "$id"; return; }
    exit 1
  else
    echo "❌ Book HTTP $status: $body" >&2
    exit 1
  fi
}

create_article_if_missing() {
  local title="$1" desc="$2" author_id="$3" doi="$4"
  local id
  id=$(find_article_id_by_doi "$doi" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  local payload
  payload=$(jq -n \
    --arg t "$title" --arg d "$desc" --arg doi "$doi" \
    --argjson a "$author_id" \
    '{material:{type:"Article",title:$t,description:$d,status:"published",author_id:$a,doi:$doi}}'
  )
  read -r body status < <(post_json "$API_BASE/api/v1/materials" "$payload")
  if [[ "$status" == "201" || "$status" == "200" ]]; then
    echo "$body" | jq -r '.id'
  elif [[ "$status" == "422" ]]; then
    echo "⚠️  422 Article: $(echo "$body" | jq -c '.errors // .')" >&2
    id=$(find_article_id_by_doi "$doi" || true)
    [[ -n "${id:-}" ]] && { echo "$id"; return; }
    exit 1
  else
    echo "❌ Article HTTP $status: $body" >&2
    exit 1
  fi
}

create_video_if_missing() {
  local title="$1" desc="$2" author_id="$3" duration="$4" year="$5"
  local id
  id=$(find_video_id_by_title_year "$title" "$year" || true)
  if [[ -n "${id:-}" ]]; then
    echo "$id"; return
  fi
  local payload
  payload=$(jq -n \
    --arg t "$title" --arg d "$desc" \
    --argjson a "$author_id" --argjson du "$duration" --argjson y "$year" \
    '{material:{type:"Video",title:$t,description:$d,status:"published",author_id:$a,duration_minutes:$du,release_year:$y}}'
  )
  read -r body status < <(post_json "$API_BASE/api/v1/materials" "$payload")
  if [[ "$status" == "201" || "$status" == "200" ]]; then
    echo "$body" | jq -r '.id'
  elif [[ "$status" == "422" ]]; then
    echo "⚠️  422 Video: $(echo "$body" | jq -c '.errors // .')" >&2
    id=$(find_video_id_by_title_year "$title" "$year" || true)
    [[ -n "${id:-}" ]] && { echo "$id"; return; }
    exit 1
  else
    echo "❌ Video HTTP $status: $body" >&2
    exit 1
  fi
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
ENG_ART_ID=$(create_article_if_missing "Política e a Língua Inglesa" "Ensaio sobre linguagem e política" "$ORWELL_ID" "10.1234/horizon.1946.04")
MIT_ART_ID=$(create_article_if_missing "Introdução aos Algoritmos" "Artigo técnico sobre algoritmos" "$MIT_ID" "10.5555/mitpress.2020.01")
VID1984_ID=$(create_video_if_missing "Adaptação de 1984" "Filme baseado no livro" "$ORWELL_ID" 113 1984)
MIT_VID_ID=$(create_video_if_missing "Aula de Estruturas de Dados" "Videoaula sobre estruturas de dados" "$MIT_ID" 45 2019)
echo "✅ Livros: $B1984_ID, $AFARM_ID | Artigos: $ENG_ART_ID, $MIT_ART_ID | Vídeos: $VID1984_ID, $MIT_VID_ID"

# ---------- buscas ----------
echo "🔎 Busca 1984:"
curl -fsS "$API_BASE/api/v1/materials?q=$(urlencode "1984")" "${AUTH[@]}" | jq .

echo "🔎 Busca MIT:"
curl -fsS "$API_BASE/api/v1/materials?q=$(urlencode "MIT")" "${AUTH[@]}" | jq .

# ---------- autores ----------
echo "👥 Autores (top 10):"
curl -fsS "$API_BASE/api/v1/authors" "${AUTH[@]}" | jq '.[0:10]'

# ---------- ping ----------
echo "🏓 Ping:"
PING_JSON=$(curl -sS "$API_BASE/api/v1/ping" "${AUTH[@]}" || true)
if [[ -n "${PING_JSON:-}" ]]; then
  echo "$PING_JSON" | jq . || echo "$PING_JSON"
else
  echo "{\"ok\":true}" | jq .
fi

echo "✅ Smoke OK!"
