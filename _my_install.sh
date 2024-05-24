#!/bin/bash

# Install and log into huggingface using access token
pip install --upgrade huggingface_hub
huggingface-cli login
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
# Updating Ubuntu
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential

# Cloning the PrivateGPT repo
git clone https://github.com/imartinez/privateGPT

# Setting Up Python Environment
# To manage Python versions, we’ll use pyenv. Follow the commands below to install it and set up the Python environment:
sudo apt-get install git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev libssl-dev openssl libffi-dev
curl https://pyenv.run | bash
export PATH="/home/$(whoami)/.pyenv/bin:$PATH"

# Add the following lines to your .bashrc file:
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Reload your terminal
source ~/.bashrc

# Install important missing pyenv stuff
sudo apt-get install lzma
sudo apt-get install liblzma-dev

# Install Python 3.11 and set it as the global version:
pyenv install 3.11
pyenv global 3.11
pip install pip --upgrade
pyenv local 3.11

# Poetry Installation
# Install poetry to manage dependencies:
curl -sSL https://install.python-poetry.org | python3 -

# Add the following line to your .bashrc:
export PATH="/home/$(whoami)/.local/bin:$PATH"

# Reload your configuration
source ~/.bashrc
poetry --version # should display something without errors

# Installing PrivateGPT Dependencies
# Navigate to the PrivateGPT directory and install dependencies:
cd privateGPT
poetry install --extras "ui embeddings-huggingface llms-llama-cpp vector-stores-qdrant"
# Nvidia Drivers Installation
# Visit Nvidia’s official website to download and install the Nvidia drivers for WSL. Choose Linux > x86_64 > WSL-Ubuntu > 2.0 > deb (network)
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.5.0/local_installers/cuda-repo-wsl-ubuntu-12-5-local_12.5.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-12-5-local_12.5.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-12-5-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-5

# Add the following lines to your .bashrc:
export PATH="/usr/local/cuda-12.5/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-12.5/lib64:$LD_LIBRARY_PATH"
# Maybe check the content of “/usr/local” to be sure that you do have the “cuda-12.4” folder. Yours might have a different version.

# Reload your configuration and check that all is working as expected
source ~/.bashrc
nvcc --version
nvidia-smi
# “nvidia-smi” isn’t available on WSL so just verify that the .exe one detects your hardware. Both commands should displayed gibberish but no apparent errors.

# Building and Running PrivateGPT
# Finally, install LLAMA CUDA libraries and Python bindings:
CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python

# Let private GPT download a local LLM for you (mixtral by default):
poetry run python scripts/setup

# To run PrivateGPT, use the following command:
make run
# This will initialize and boot PrivateGPT with GPU support on your WSL environment.

# You should see "BLAS = 1" if GPU offload is working (2md to last line below)
# ...............................................................................................
# llama_new_context_with_model: n_ctx      = 3900
# llama_new_context_with_model: freq_base  = 1000000.0
# llama_new_context_with_model: freq_scale = 1
# llama_kv_cache_init:      CUDA0 KV buffer size =   487.50 MiB
# llama_new_context_with_model: KV self size  =  487.50 MiB, K (f16):  243.75 MiB, V (f16):  243.75 MiB
# llama_new_context_with_model: graph splits (measure): 3
# llama_new_context_with_model:      CUDA0 compute buffer size =   275.37 MiB
# llama_new_context_with_model:  CUDA_Host compute buffer size =    15.62 MiB
# AVX = 1 | AVX_VNNI = 0 | AVX2 = 1 | AVX512 = 0 | AVX512_VBMI = 0 | AVX512_VNNI = 0 | FMA = 1 | NEON = 0 | ARM_FMA = 0 | F16C = 1 | FP16_VA = 0 | WASM_SIMD = 0 | BLAS = 1 | SSE3 = 1 | SSSE3 = 1 | VSX = 0 |
# 18:50:50.097 [INFO    ] private_gpt.components.embedding.embedding_component - Initializing
