#!/bin/sh
#Bash script for installing conda environments for tensorflow.
cpuenv="tensorflow"
gpuenv="tensorflow-gpu"

conda create -n $cpuenv
#install pip INSIDE the environment
conda install -n $cpuenv pip
source activate $cpuenv
#inside $cpuenv now
# CPUENV {

pip install tensorflow
#test tensorflow
python -c "from tensorflow.python.client import device_lib;print(device_lib.list_local_devices())" | grep cpu

pip install keras
pip install keras-vis
#list what you installed
conda list

# } CPUENV 
source deactivate 

conda create -n $gpuenv
#install pip INSIDE the environment
conda install -n $gpuenv pip
source activate $gpuenv
#inside $gpuenv now
# GPUENV {

pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.3.0-cp36-cp36m-linux_x86_64.whl
#test tensorflow
python -c "from tensorflow.python.client import device_lib;print(device_lib.list_local_devices())" | grep gpu

pip install keras
pip install keras-vis
conda list

# } GPUENV 
source deactivate 
