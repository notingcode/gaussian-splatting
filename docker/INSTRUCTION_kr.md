# 도커 빌드 및 빌드된 컨테이너 실행

## 빌드

```[bash]
# GPU에 컨테이너 접근을 허용하기 위해 모든 명령어는 sudo 권한으로 실행해야 합니다.
# 호스트 컴퓨터에 'nvidia-container-toolkit'이 설치되어 있는지 확인하세요.

sudo docker build --build-arg user=$USER -t splat .
```

- 빌드 정보는 Dockerfile을 확인하세요.

### [NVIDIA 컨테이너 툴킷](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

- **Docker CLI가 이미 설치되어 있다면**, 위 NVIDIA 웹사이트의 지시에 따라 컨테이너 도구를 설치하세요.

## X11 Forwarding

```[bash]
# 호스트의 쉘에서 실행하세요.
xhost +local:docker
```

도커에게 호스트의 X 서버 접근 권한을 제공합니다.

## 컨테이너 실행

```[bash]
# 이 명령어는 리눅스 데스크탑 환경에서만 실행됩니다.
# GPU에 컨테이너 접근을 허용하기 위해 모든 명령어는 sudo 권한으로 실행해야 합니다.

sudo docker run -it --gpus all --net=host -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix/:/tmp/.X11-unix splat
```

위 명령어를 우분투나 다른 리눅스 배포판에서 실행하면, 컨테이너에 연결된 bash 쉘 사용이 가능합니다.
호스트의 디스플레이, X 네트워크 소켓이 컨테이너에 전달됩니다.
훈련데이터 볼륨을 컨테이너에 연결하거나 컨테이너로부터 결과를 다운로드하기 위해 docker run [-v] 및 docker cp [params]를 확인하세요.

## SIBR 뷰어 공지

- 뷰어를 실행할 때 발생하는 OpenGL/CUDA interop 오류는 아직 해결되지 않았습니다. 가까운 미래에 수정될 예정입니다.
