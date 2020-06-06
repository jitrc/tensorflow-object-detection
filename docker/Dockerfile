ARG FROM_IMAGE_NAME=tensorflow/tensorflow:latest-py3
FROM ${FROM_IMAGE_NAME}

ARG DEBIAN_FRONTEND=noninteractive

# Common Tools
RUN apt-get update && apt-get install -y \
  curl \
  git \
  software-properties-common \
  sudo \
  terminator \
  tree \
  unzip \
  wget

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Common Python tools/libs
RUN pip install --upgrade pip
RUN pip install --no-cache-dir \
  absl-py \
  jupyterlab \
  matplotlib \
  numpy \
  opencv-python \
  pandas \
  pillow \
  sklearn


# Dependencies
RUN apt-get install -y python-tk && \
    pip install --no-cache-dir Cython matplotlib lxml pillow && \
    pip install --no-cache-dir contextlib2 tf_slim pycocotools


# Get protoc 3.0.0, rather container may have different version
# sometimes "sudo apt-get install protobuf-compiler" will install Protobuf 3+ versions for you and some users have issues when using 3.5
RUN cd /tmp && curl -OL "https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    chmod 755 /usr/local/bin/protoc && \
    rm -rf proto3 protoc-3.0.0-linux-x86_64.zip


# Get the tensorflow models research directory, in /tensorflow to match recommendation of installation
ARG TF_MODEL_BRANCH=master
RUN mkdir -p /tensorflow && cd /tensorflow &&\
    git clone --depth 1 https://github.com/tensorflow/models.git -b ${TF_MODEL_BRANCH} 

# Run protoc on the object detection repo
RUN cd /tensorflow/models/research && \
    protoc object_detection/protos/*.proto --python_out=.


# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim
ENV TF_OBJECT_DETECTION_API /tensorflow/models/research/object_detection


WORKDIR /home
EXPOSE 8888
CMD ["jupyter", "lab", "--allow-root","--NotebookApp.token=''", "--notebook-dir=/home/", "--ip=0.0.0.0", "--port=8888", "--no-browser"]