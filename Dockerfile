FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Clone tensorrtx repository (optional, if you want to include it in the image)
RUN git clone https://github.com/R2botics/tensorrtx.git

RUN apt-get update && apt-get install -y \
    git \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /workspace/
RUN pip install --no-cache-dir -r /workspace/requirements.txt

COPY . /workspace/
CMD ["/bin/bash", "convert_all.sh"]