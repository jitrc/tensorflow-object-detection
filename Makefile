PROJECT ?= tensorflow-object-detection
WORKSPACE ?= /home/workspace

DOCKER_TAG ?= 1.15.0-gpu-py3  # latest-py3, 2.0.0-gpu-py3, 1.15.0-gpu-py3
DOCKER_BASE_IMG ?=tensorflow/tensorflow:${DOCKER_TAG}
DOCKER_IMAGE ?= ${PROJECT}:${DOCKER_TAG}

SHMSIZE ?= 32G

DOCKER_OPTS := \
	    --name ${PROJECT} \
	    --rm -it \
	    --shm-size=${SHMSIZE} \
	    --gpus all \
	    -v /data:/data \
            -v /media:/media \
	    -v ${PWD}:${WORKSPACE} \
	    -w ${WORKSPACE} \
	    --privileged \
	    --ipc=host \
	    --network=host

.PHONY: all clean docker-build 

all: clean

clean:
	find . -name "*.pyc" | xargs rm -f && \
	find . -name "__pycache__" | xargs rm -rf

docker-build:
	docker build \
	    --build-arg FROM_IMAGE_NAME=${DOCKER_BASE_IMG} \
		-f docker/Dockerfile \
		-t ${DOCKER_IMAGE} .

docker-run-bash: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} bash

docker-run-jupyter: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} \
		bash -c "jupyter lab --port=8888 --ip=0.0.0.0 --allow-root --notebook-dir=${WORKSPACE}/nb --no-browser"

docker-run-default: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE}

docker-run-cmd: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} \
		bash -c "${CMD}"

