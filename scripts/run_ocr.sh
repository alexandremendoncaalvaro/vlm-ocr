#!/usr/bin/env bash
set -euo pipefail

# Conveniência para rodar OCR com modelo multimodal + llama.cpp já compilado.
# Pode sobrescrever variáveis: MODEL, MMPROJ, IMAGE, LLAMA_BIN, NGL, CTX.

ROOT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Defaults: MiniCPM-V 2.6 (Q4_K_M) + mmproj f16 — melhor OCR e já baixado.
MODEL="${MODEL:-$ROOT_DIR/models/minicpmv2_6.Q4_K_M.gguf}"
MMPROJ="${MMPROJ:-$ROOT_DIR/models/minicpmv2_6-mmproj-f16.gguf}"
IMAGE="${IMAGE:-$ROOT_DIR/imagens/001.jpg}"
LLAMA_BIN="${LLAMA_BIN:-$HOME/dev/llama.cpp/build/bin/llama-mtmd-cli}" # cli multimodal atual
NGL="${NGL:-999}"  # use toda a VRAM disponível por padrão
CTX="${CTX:-2048}" # mais contexto para OCR

if [[ ! -x "$LLAMA_BIN" ]]; then
  echo "Erro: binário não encontrado/executável em LLAMA_BIN='$LLAMA_BIN'." >&2
  echo "Compile o llama.cpp (ex.: cmake --build build --config Release) ou ajuste a variável." >&2
  exit 1
fi

[[ -f "$MODEL" ]] || { echo "Modelo não encontrado: $MODEL" >&2; exit 1; }
[[ -f "$MMPROJ" ]] || { echo "mmproj não encontrado: $MMPROJ" >&2; exit 1; }
[[ -f "$IMAGE" ]] || { echo "Imagem não encontrada: $IMAGE" >&2; exit 1; }

echo "Usando imagem: $IMAGE"
echo "Modelo: $MODEL"
echo "mmproj: $MMPROJ"
echo "Executável: $LLAMA_BIN"
echo "----------------------------"

"$LLAMA_BIN" \
  -m "$MODEL" \
  --mmproj "$MMPROJ" \
  --image "$IMAGE" \
  -c "$CTX" \
  -ngl "$NGL" \
  --temp 0 \
  -p "Transcreva todo o texto da imagem exatamente, linha a linha."
