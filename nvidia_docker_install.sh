# https://takake-blog.com/ubutnu2004-install-nvidia-docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# /etc/apt/sources.list.d/nvidia-docker.list のファイルを自分のubuntuのバージョンにする
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime nvidia-smi