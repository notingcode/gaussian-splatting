FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Do not check for keyboard type
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

COPY . /home/gaussian-splatting

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    && apt-get install -y \
    git cmake gcc-11 g++-11 \
    ninja-build build-essential \
    wget bzip2 \
    libboost-all-dev \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libassimp-dev libgtk-3-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libglfw3-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglm-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    libopencv-dev \
    libavdevice-dev \
    libavcodec-dev libeigen3-dev libxxf86vm-dev libembree-dev

ENV PATH="/usr/local/cuda-11.8/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_PATH="/usr/local/cuda-11.8"
ENV CUDA_HOME="/usr/local/cuda-11.8"
ENV CC="/usr/bin/gcc-11"
ENV CXX="/usr/bin/g++-11"
ENV CUDAHOSTCXX="/usr/bin/g++-11"

# Install COLMAP from source
# RUN git clone https://github.com/colmap/colmap.git \
#     && cd colmap \
#     && mkdir build \
#     && cd build \
#     && cmake .. -G Ninja -D CMAKE_CUDA_ARCHITECTURES=native \
#     && ninja \
#     && ninja install

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /etc/miniconda \
    && rm /tmp/miniconda.sh

ENV PATH="/etc/miniconda/bin:${PATH}"

# Create a Conda environment with your desired packages

RUN conda init

RUN conda env create --file /home/gaussian-splatting/docker_conda_environment.yml

# RUN cd SIBR_viewers \
#     && cmake -Bbuild . -DCMAKE_BUILD_TYPE=Release -GNinja \
#     && cmake --build build -j24 --target install

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm ./cuda-keyring_1.0-1_all.deb