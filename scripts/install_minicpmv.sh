#!/usr/bin/env bash
set -euo pipefail

# Baixa MiniCPM-V 2.6 GGUF (Q4_K_M) + mmproj f16.
# Usa HF_TOKEN (opcional) se definido em .env ou no ambiente.

ROOT="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT}/.env}"

if [[ -f "$ENV_FILE" ]]; then
  set -o allexport
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +o allexport
fi

HF_TOKEN="${HF_TOKEN:-}"
MODEL_DIR="${MODEL_DIR:-$ROOT/models}"
MODEL_FILE="${MODEL_FILE:-minicpmv2_6.Q4_K_M.gguf}"
MMPROJ_FILE="${MMPROJ_FILE:-minicpmv2_6-mmproj-f16.gguf}"
MODEL_URL="${MODEL_URL:-https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/ggml-model-Q4_K_M.gguf}"
MMPROJ_URL="${MMPROJ_URL:-https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/mmproj-model-f16.gguf}"

mkdir -p "$MODEL_DIR"
auth_header=()
if [[ -n "$HF_TOKEN" ]]; then
  auth_header=(--header "Authorization: Bearer ${HF_TOKEN}")
fi

download() {
  local url="$1"
  local out="$2"
  echo "↓ Downloading ${out}"
  curl -L --fail "${auth_header[@]}" -o "$out" "$url"
}

download "$MODEL_URL" "${MODEL_DIR}/${MODEL_FILE}"
download "$MMPROJ_URL" "${MODEL_DIR}/${MMPROJ_FILE}"

echo "Done. Files saved to ${MODEL_DIR}"
