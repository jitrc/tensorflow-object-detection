# Tensorflow Object Detection

## Docker

Build
```
make docker-build
```

Bash into docker
```
make docker-run-bash
```

Jupyter Lab in docker
```
make docker-run-jupyter
```

Test
```
make docker-run-cmd CMD="python /tensorflow/models/research/object_detection/builders/model_builder_test.py"
```

