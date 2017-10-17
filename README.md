# Addtions to Tensorflow GPU install on ubuntu 16.04    

Small additions and notes (for myself and others willing to try it) to [Tensorflow GPU install on ubuntu 16.04](https://github.com/williamFalcon/tensorflow-gpu-install-ubuntu-16.04).

Additions include:

- Added some comments w.r.t. problems I ran into.
- Updated some versions (cuda8-v5.1 -> cuda8-v6.0; tensorflow 1.2 -> tensorflow 1.3)
- Added sha256 checksums for the binaries I used.
- Added checksum checks.
	
-1. Make sure you have proprietary NVIDIA drivers first
Using the `Software & Updates` ubuntu application under the `Additional Drivers`tab select the nvidia-384 proprietary drivers and click `Apply Changes`. 

![Image of ubuntu Software & Updates, Additional Drivers tab](https://github.com/dietercastel/tensorflow-gpu-install-ubuntu-16.04/raw/master/proprietary_drivers.png)

0. update apt-get   
``` bash 
sudo apt-get update
```
   
1. Install apt-get deps  
``` bash
sudo apt-get install openjdk-8-jdk git python-dev python3-dev python-numpy python3-numpy build-essential python-pip python3-pip python-virtualenv swig python-wheel libcurl3-dev curl
```
*Comment: added curl for step 2 (wget would also work but whatever)*

2. install nvidia drivers 
``` bash
# The 16.04 installer works with 16.10.
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
echo "9ef12d64d5db7229c37eb40349f1734b69501865d0530da96bdd6d063d80fb47  cuda-repo-ubuntu1604_8.0.61-1_amd64.deb" | sha256sum -c
sudo dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda -y
```  
*Comment: added sudo and a checksum verification command.*

2a. check nvidia driver install 
``` bash
nvidia-smi   

# you should see a list of gpus printed    
# if not, the previous steps failed.   
``` 
*Comment:
When I had no nvidia proprietary graphics card drivers installed (step -1) I got the folloing message:
'NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running.' Doing step -1 should remedy this.
If succesful you get this kind of output:
*
``` 
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 384.66                 Driver Version: 384.66                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 106...  Off  | 00000000:01:00.0  On |                  N/A |
|  0%   37C    P8    11W / 180W |    224MiB /  6064MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|    0      1029    G   /usr/lib/xorg/Xorg                             175MiB |
|    0      1736    G   compiz                                          45MiB |
|    0      2016    G   unity-control-center                             1MiB |
+-----------------------------------------------------------------------------+
``` 

3. install cuda toolkit (MAKE SURE TO SELECT N TO INSTALL NVIDIA DRIVERS)
``` bash
wget https://s3.amazonaws.com/personal-waf/cuda_8.0.61_375.26_linux.run   
echo "9ceca9c2397f841024e03410bfd6eabfd72b384256fbed1c1e4834b5b0ce9dc4  cuda_8.0.61_375.26_linux.run" | sha256sum -c 
sudo sh cuda_8.0.61_375.26_linux.run   # press and hold s to skip agreement   

# Do you accept the previously read EULA?
# accept

# Install NVIDIA Accelerated Graphics Driver for Linux-x86_64 361.62?
# ************************* VERY KEY ****************************
# ******************** DON"T SAY Y ******************************
# n

# Install the CUDA 8.0 Toolkit?
# y

# Enter Toolkit Location
# press enter


# Do you want to install a symbolic link at /usr/local/cuda?
# y

# Install the CUDA 8.0 Samples?
# y

# Enter CUDA Samples Location
# press enter    

# now this prints: 
# Installing the CUDA Toolkit in /usr/local/cuda-8.0 …
# Installing the CUDA Samples in /home/liping …
# Copying samples to /home/liping/NVIDIA_CUDA-8.0_Samples now…
# Finished copying samples.
```    
*Comment: williamFalcon provided the binary from his own s3 /personal-waf. If you want to get the file straight from nvidia you have to sign up as developer (as far as I can tell checksum is legit). Added a checksum check with the binary I used that worked.*

4. Install cudnn   
``` bash
wget http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz
echo "9b09110af48c9a4d7b6344eb4b3e344daa84987ed6177d5c44319732f3bb7f9c  cudnn-8.0-linux-x64-v6.0.tgz" | sha256sum -c 
sudo tar -xzvf cudnn-8.0-linux-x64-v6.0.tgz   
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```    
*Comment: I updated the link for cuda 8.0-v6.0 and added checksum check.*

5. Add these lines to end of ~/.bashrc:   
``` bash
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
```   

6. Reload bashrc     
``` bash 
source ~/.bashrc
```   

7. Install miniconda   
``` bash
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh   

# press s to skip terms   

# Do you approve the license terms? [yes|no]
# yes

# Miniconda3 will now be installed into this location:
# accept the location

# Do you wish the installer to prepend the Miniconda3 install location
# to PATH in your /home/ghost/.bashrc ? [yes|no]
# yes    

```   

8. Reload bashrc     
``` bash 
source ~/.bashrc
```   

9. Create conda env to install tf   
``` bash
conda create -n tensorflow-gpu

# press y a few times 
```   
*Comment: changed the name to tensorflow-gpu because I find it useful to also have a cpu conda environment.*

10. Activate env   
``` bash
source activate tensorflow-gpu   
```
*Comment: updated name accordingly* 

11. Install tensorflow with GPU support for python 3.6    
``` bash
# pip install --ignore-installed --upgrade aTFUrl
pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.3.0-cp36-cp36m-linux_x86_64.whl
```   

12. Test tf install   
``` bash
# start python shell   
python

# run test script   
import tensorflow as tf   

hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))
```  
