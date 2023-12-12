# Docker Build and Running Built Container

## Build

```[bash]
# Must run all commands with sudo privilege in order to give container access to GPU
# Make sure you have 'nvidia-container-toolkit' installed on your host computer

sudo docker build --build-arg user=$USER -t openpose .
```

- Check Dockerfile for build info.

### [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

- Follow instruction on NVIDIA's website above to install container tool assuming **Docker CLI is already installed**.

## Run Container

```[bash]
# This command only runs on Linux desktop environment
# Must run all commands with sudo privilege in order to give container access to GPU

sudo docker run -it --gpus all --net=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix/:/tmp/.X11-unix openpose
```

After running the above command in Ubuntu or any Linux distros, bash shell attached to the container will be available.
Display and host's X11 network socket is passed to the container before running.
Check docker run [-v] and docker cp [params] to attach training data volume to container and download result from container to host.

## SIBR Viewer Notice

- OpenGL/CUDA interop error when launching viewer is not fixed as of now. It will be fixed in the near future.
