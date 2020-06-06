PROJECT ?= tensorflow-object-detection
MOUNT_WORKSPACE_TO ?= /home/

TF_MODEL_BRANCH ?= r1.13.0
DOCKER_TAG ?= 1.13.2-gpu-py3  # latest-py3, 2.0.0-gpu-py3, 1.14.0-gpu-py3
DOCKER_BASE_IMG ?=tensorflow/tensorflow:${DOCKER_TAG}
DOCKER_IMAGE ?= ${PROJECT}:${DOCKER_TAG}

CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)
DATA ?= ${PWD}/data
SHMSIZE ?= 32G

DOCKER_OPTS := \
	--name ${PROJECT} \
	--rm -it \
	--gpus all \
	--shm-size=${SHMSIZE} \
	-u ${CURRENT_UID}:${CURRENT_GID} \
	-v /etc/passwd:/etc/passwd:ro \
	-v /etc/group:/etc/group:ro \
	-v ${DATA}:/data \
	-v /media:/media \
	-v ${PWD}/workspace:${MOUNT_WORKSPACE_TO} \
	-w ${MOUNT_WORKSPACE_TO} \
	-e HOME=${MOUNT_WORKSPACE_TO}/docker_home \
	-e TF_CPP_MIN_LOG_LEVEL=1 \
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
		--build-arg TF_MODEL_BRANCH=${TF_MODEL_BRANCH} \
		-f docker/Dockerfile \
		-t ${DOCKER_IMAGE} .

docker-run-bash: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} bash

docker-run-jupyter: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} \
		bash -c "jupyter lab --port=8888 --ip=0.0.0.0 --allow-root \
		--NotebookApp.token='' --notebook-dir=${MOUNT_WORKSPACE_TO} --no-browser"

docker-run-default: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE}

docker-run-cmd: docker-build
	docker run ${DOCKER_OPTS} ${DOCKER_IMAGE} \
		bash -c "${CMD}"

