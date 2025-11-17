#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT}/.env}"

# Load .env if present
if [[ -f "$ENV_FILE" ]]; then
  set -o allexport
  # shellcheck source=/dev/null
  source "$ENV_FILE"
  set +o allexport
fi

HF_TOKEN="${HF_TOKEN:-}"
MODEL_DIR="${MODEL_DIR:-$ROOT/models}"
MODEL_QUANT="${MODEL_QUANT:-llava-v1.6-mistral-7b.Q4_K_M.gguf}"
MMPROJ_FILE="${MMPROJ_FILE:-mmproj-model-f16.gguf}"
MODEL_URL="${MODEL_URL:-https://huggingface.co/mradermacher/llava-v1.6-mistral-7b-GGUF/resolve/main/$MODEL_QUANT}"
MMPROJ_URL="${MMPROJ_URL:-https://huggingface.co/liuhaotian/llava-v1.6-mistral-7b/resolve/main/mmproj-model-f16.gguf}"

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

download "$MODEL_URL" "${MODEL_DIR}/${MODEL_QUANT}"
download "$MMPROJ_URL" "${MODEL_DIR}/${MMPROJ_FILE}"

echo "Done. Files saved to ${MODEL_DIR}"
