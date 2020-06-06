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

# Common Python tools/libs
RUN pip install --upgrade pip
RUN pip install --no-cache-dir \
  absl-py \
  jupyter \
  jupyterlab \
  matplotlib \
  numpy \
  pandas \
  pillow \
  sklearn

# Dependencies
RUN apt-get install -y \
  protobuf-compiler \
  python-lxml \
  python-pil \
  build-essential \
  cmake pkg-config \
  python-tk

# Python dependencies
RUN pip install --no-cache-dir Cython==0.29.2
RUN pip install --no-cache-dir contextlib2==0.5.5
RUN pip install --no-cache-dir opencv-python==3.4.0.12
RUN pip install --no-cache-dir tf_slim
RUN pip install --no-cache-dir pycocotools

WORKDIR /home

# Tensorflow models
RUN git clone https://github.com/tensorflow/models.git

WORKDIR models/research/
RUN protoc object_detection/protos/*.proto --python_out=.
RUN pip install -e .
RUN cd slim && pip install -e .

RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py


EXPOSE 8888
CMD ["jupyter", "lab", "--allow-root", "--notebook-dir=/home/", "--ip=0.0.0.0", "--port=8888", "--no-browser"]