#!/bin/bash

# 定义镜像名称和版本
IMAGE_NAME="sf-express"
IMAGE_VERSION="v3"

# 定义容器名称
CONTAINER_NAME="sleepy_villani"

# 定义宿主机的端口
HOST_PORT=8081

# 定义容器的端口
CONTAINER_PORT=80

# 检查并删除已存在的同名容器
echo "Checking for existing container..."
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
    echo "Stopping and removing existing container ${CONTAINER_NAME}..."
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
fi

# 检查并删除已存在的同名镜像
echo "Checking for existing image..."
if [ "$(docker images -q ${IMAGE_NAME}:${IMAGE_VERSION})" ]; then
    echo "Removing existing image ${IMAGE_NAME}:${IMAGE_VERSION}..."
    docker rmi ${IMAGE_NAME}:${IMAGE_VERSION}
fi

# 构建 Docker 镜像
echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} ./

# 检查镜像构建是否成功
if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting..."
    exit 1
fi

echo "Docker image built successfully."

# 运行 Docker 容器，并将容器的端口映射到宿主机的端口
echo "Running Docker container..."
docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} -v ${PWD}/resource:/usr/share/nginx/html/resource --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_VERSION}

# 检查容器是否运行成功
if [ $? -ne 0 ]; then
    echo "Docker run failed. Exiting..."
    exit 1
fi

echo "Docker container ${CONTAINER_NAME} is running with port ${CONTAINER_PORT} mapped to host port ${HOST_PORT}."