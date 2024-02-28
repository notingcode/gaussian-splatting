# Docker Build and Running Built Container

## How to start build

If **Docker Desktop** is installed, make sure the image is built with `sudo` privilege. If `sudo` privilege is not used, the image will not be visible to the local docker engine.

Run all the following commands in the base directory of the repository

```[bash]
sudo docker build --build-arg user=$USER --build-arg uid=$UID -t splat:base docker
```

- Check Dockerfile for build details.

[Install NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) to allow access to host GPU before following the next instruction.

## Docker run container (Linux and WSL)

### Run container without GUI support

Current directory will be attached to the container as volume in /home/${USER}/gaussian-splatting.

```[bash]
sudo docker run -it --rm --gpus all -v .:/home/${USER}/gaussian-splatting splat:base
```

### RUN with GUI support

```[bash]
sudo docker run -it --rm --gpus all --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v .:/home/${USER}/gaussian-splatting splat:base
```

### Build SIBR Viewer (Do this just once)

```[bash]
# Project setup
cd SIBR_viewers
cmake -Bbuild . -DCMAKE_BUILD_TYPE=Release # add -G Ninja to build faster
cmake --build build -j24 --target install
```

## SIBR Viewer Unsolved Error

- When launching SIBR viewer with interop enabled, OpenGL/CUDA interop error occurs that forces scene rendering to be done on the CPU. The solution to this problem is still not found. Hence, when launching SIBR viewer, add option `--no-interop` in the command.
