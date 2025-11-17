# VLM OCR helper

Scripts para testar OCR com `llama.cpp` (GPU ou CPU) e modelos multimodais em GGUF.

## Instalação rápida (com ou sem GPU)
Pré-requisitos: `git`, `cmake`, `curl`, `c++` toolchain. Para GPU: CUDA instalado.

1) Clone o `llama.cpp` e compile (GPU + CPU):
```bash
git clone https://github.com/ggerganov/llama.cpp.git ~/dev/llama.cpp
cd ~/dev/llama.cpp
cmake -B build -DCMAKE_BUILD_TYPE=Release -DLLAMA_CUDA=ON -DLLAMA_CUBLAS=ON
cmake --build build -j
```
   - Se não tiver GPU/CUDA, remova as flags `-DLLAMA_CUDA=ON -DLLAMA_CUBLAS=ON`.

2) Nesta pasta, copie `.env.example` para `.env` (apenas se quiser HF token privado):
```bash
cd /home/ale/dev/vlm-ocr
cp .env.example .env
# opcional: edite HF_TOKEN=... se precisar de token
```

3) Baixe modelo e mmproj (MiniCPM-V 2.6, bom para OCR) em `models/`:
```bash
chmod +x scripts/install_minicpmv.sh
scripts/install_minicpmv.sh
```
   - Usa `HF_TOKEN` se definido, senão baixa público.

## Rodar OCR com llama.cpp
Use o script de conveniência (aponta por padrão para MiniCPM-V 2.6 Q4_K_M + mmproj f16):
```bash
./scripts/run_ocr.sh                        # padrão: imagens/001.jpg
IMAGE=/caminho/imagem.jpg ./scripts/run_ocr.sh
# limitar VRAM: NGL=60 ./scripts/run_ocr.sh
```
- O script chama `~/dev/llama.cpp/build/bin/llama-mtmd-cli`.
- Se quiser outro modelo, sobrescreva `MODEL` e `MMPROJ`.

## Script legado (LLaVA 1.6)
`scripts/download_llava.sh` baixa LLaVA 1.6 Mistral Q4_K_M + mmproj f16. Só use se precisar desse modelo; o padrão atual é MiniCPM-V 2.6.
