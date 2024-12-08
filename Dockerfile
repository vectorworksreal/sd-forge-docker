FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# Install Python and git
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /stable-diffusion

# Clone the repository
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge .

# Install torch and xformers first
RUN pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install --no-cache-dir xformers

# Install Python dependencies from the cloned repository
RUN pip3 install --no-cache-dir -r requirements_versions.txt

# Create model directories and download models
RUN mkdir -p models/Stable-diffusion \
    models/VAE \
    models/ESRGAN \
    models/Lora && \
    wget -O models/Stable-diffusion/cyberrealistic_v60.safetensors https://huggingface.co/pavi301/cyberrealistic_v60/resolve/main/cyberrealistic_v60.safetensors && \
    wget -O models/Stable-diffusion/cyberrealistic_classic_v40.safetensors https://huggingface.co/pavi301/cyberrealistic_classic_v40/resolve/main/cyberrealistic_classic_v40.safetensors && \
    wget -O models/VAE/vae-ft-mse-840000-ema-pruned.safetensors https://huggingface.co/pavi301/sd-upscaler-vae/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors && \
    wget -O models/ESRGAN/8x_NMKD-Superscale_150000_G.pth https://huggingface.co/pavi301/sd-upscaler-vae/resolve/main/8x_NMKD-Superscale_150000_G.pth && \
    wget -O models/ESRGAN/4x_NMKD-Superscale-SP_178000_G.pth https://huggingface.co/pavi301/sd-upscaler-vae/resolve/main/4x_NMKD-Superscale-SP_178000_G.pth

# Expose port for WebUI (default port used by Stable Diffusion WebUI)
EXPOSE 7860

# Set environment variables for better container compatibility
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV LISTEN_PORT=7860

# Launch command
CMD ["python3", "launch.py", "--listen"]