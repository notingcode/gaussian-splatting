FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

# Do not check for keyboard type and answer with default
ENV DEBIAN_FRONTEND=noninteractive

ARG user
ARG uid
ARG gid

ENV USERNAME ${user}

RUN useradd -m ${USERNAME} && \
    echo "${USERNAME}:${USERNAME}" | chpasswd && \
    usermod -s /bin/bash ${USERNAME} && \
    usermod -u ${uid} ${USERNAME}

ENV PATH="/usr/local/cuda-11.7/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:${LD_LIBRARY_PATH}"
ENV CUDA_PATH="/usr/local/cuda-11.7"
ENV CUDA_HOME="/usr/local/cuda-11.7"
ENV TORCH_CUDA_ARCH_LIST="8.0 8.6"

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    && apt-get install -qqy x11-apps \
    && apt-get install -y \
    git gcc-12 g++-12 \
    ninja-build build-essential \
    wget bzip2 tar\
    libglew-dev libglm-dev libassimp-dev \
    libboost-all-dev libgtk-3-dev \
    libopencv-dev libglfw3-dev libatlas-base-dev \
    libavdevice-dev libavcodec-dev \
    libeigen3-dev libxxf86vm-dev libembree-dev \
    libsuitesparse-dev libfreeimage-dev \
    libmetis-dev libgoogle-glog-dev \
    libgflags-dev libpcl-dev \
    qtbase5-dev libqt5opengl5-dev \
    libcgal-dev libcgal-qt5-dev

# Install cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.4/cmake-3.24.4.tar.gz \
    && tar -xzf cmake-3.24.4.tar.gz \
    && cd cmake-3.24.4 \
    && ./bootstrap && make && make install

RUN rm -rf cmake-3.24.4 && rm cmake-3.24.4.tar.gz

RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz \
    && tar zxf ceres-solver-2.1.0.tar.gz \
    && mkdir ceres-bin \
    && cd ceres-bin \
    && cmake ../ceres-solver-2.1.0 -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF -DCMAKE_CUDA_ARCHITECTURES=native \
    && make -j3 \
    && make test \
    # Optionally install Ceres, it can also be exported using CMake which
    # allows Ceres to be used without requiring installation, see the documentation
    # for the EXPORT_BUILD_DIR option for more information.
    && make install

RUN rm -rf ceres-solver-2.1.0 && rm ceres-solver-2.1.0.tar.gz

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh \
    && bash Miniconda3-py37_23.1.0-1-Linux-x86_64.sh -b -p /home/${user}/miniconda \
    && rm Miniconda3-py37_23.1.0-1-Linux-x86_64.sh

ENV PATH="/home/${user}/miniconda/bin:${PATH}"

RUN conda init bash

WORKDIR /home/${user}

RUN git clone https://github.com/notingcode/gaussian-splatting.git --recursive

WORKDIR /home/${user}/gaussian-splatting

RUN rm -rf docker

WORKDIR /home/${user}/gaussian-splatting/colmap-pcd

RUN mkdir build

RUN cd build \
    && cmake .. -DCUDA_ENABLED=ON -DCMAKE_CUDA_ARCHITECTURES=native \
    && make -j \
    && make install

WORKDIR /home/${user}/gaussian-splatting

RUN cd SIBR_viewers \
    && cmake -Bbuild . -DCMAKE_BUILD_TYPE=Release -GNinja \
    && cmake --build build -j24 --target install

# Reset DEBIAN_FRONTEND to default
ENV DEBIAN_FRONTEND=dialog

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Gaussian-splatting conda env setup

RUN conda install -y --file requirements_conda.txt -c pytorch -c nvidia -c defaults -c conda-forge
RUN pip install ./submodules/diff-gaussian-rasterization
RUN pip install ./submodules/simple-knn

USER ${user}