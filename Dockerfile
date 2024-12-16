FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /stable-diffusion

RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge .

RUN pip3 install --no-cache-dir torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install --no-cache-dir xformers

RUN pip3 install --no-cache-dir -r requirements_versions.txt

EXPOSE 7860

ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0
ENV LISTEN_PORT=7860

# Set environment variables for better container compatibility
ENV PYTHONUNBUFFERED=1
ENV GRADIO_SERVER_NAME=0.0.0.0

# Command to run the WebUI with necessary flags
CMD ["python3", "launch.py", "--listen", "--enable-insecure-extension-access", "--api"]
