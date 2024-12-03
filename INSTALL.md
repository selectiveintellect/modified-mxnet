# INSTALLATION

For now, this version has only been tested on Linux with NVIDIA GPUs that
support CUDA 12.x.

## PREREQUISITES

- Run `git clone --recursive https://github.com/apache/incubator-mxnet mxnet` 
- Install pre-requisites:

```
$ sudo apt-get update
$ sudo apt-get install -y build-essential git ninja-build ccache \
    libopenblas-dev libopencv-dev cmake gfortran htop
$ sudo apt-get -y install gcc-12 g++-12 gfortran-12
```
- If you have NVIDIA GPUs installed on the Linux system, install CUDA 12.6 SDK
- The older CUDA 12.2 SDK is not supported at the moment due to header file
  issues.

```
$ which nvcc
/usr/local/cuda/bin/nvcc
```

## PATCH HEADER FILES IN CUDA

Patch CUDA header file in CUDA 12.6 SDK
`/usr/local/cuda/include/cub//device/dispatch/dispatch_histogram.cuh` and change
all invocations of `cuda::` to look like `::cuda::`, to avoid the compiler
producing ambiguous errors. In CUDA 12.6 SDK this will be in line 422.

In CUDA 12.2 SDK this will be in several lines.

Reported issue: <https://github.com/NVIDIA/cccl/issues/2939>

The reason this is done is that c++11 compilers like gcc-11 or gcc-12 seems to
confuse itself for the `::cuda` namespace and the various sub-namespaces also
named `cuda` in the MXNet repository. Fixing this one header file solves the
issues with compiling. You only need to do this if your CUDA SDK version is
between 12.0 and 12.6. We believe that based on the above reported issue and the
fix, it will not be necessary in CUDA SDK 12.7 or greater.

## CPU ONLY BUILD

- Run `cmake` with accceptable defaults. For pure CPU-only computations, you
  have to disable CUDA support using the `USE_CUDA` option.

```
$ mkdir -p _build_cpu
## or use your own custom install directory like /usr/local or $HOME/local
$ export CMAKE_INSTALL_PREFIX=${HOME}/local/cpu
$ mkdir -p $CMAKE_INSTALL_PREFIX
$ cd _build_cpu
$ cmake -DUSE_CPP_PACKAGE=1 -DUSE_CUDA=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ..
$ make -j4
$ make install
$ cd ..
```

## CUDA BUILD

- Run `cmake` with accceptable defaults, and set `USE_CUDA` to `ON`.

```
$ mkdir -p _build_cuda
## or use your own custom install directory like /usr/local or $HOME/local
$ export CMAKE_INSTALL_PREFIX=${HOME}/local/mxnet/cuda
$ mkdir -p $CMAKE_INSTALL_PREFIX
$ cd _build_cuda
$ CC=gcc-12 CXX=g++-12 FC=gfortran-12 cmake \
    -DUSE_CPP_PACKAGE=1 -DUSE_CUDA=ON \
    -DMXNET_CUDA_ARCH=7.5 \
    -DCMAKE_CUDA_ARCHITECTURES=sm_75 \
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ..
$ make -j4
$ make install
$ cd ..
```

### RECOMMENDED TOOLS

To check if the CUDA-enabled GPU is being used, we recommend you install
`nvtop`.

```
$ sudo apt -y install libdrm-dev libsystemd-dev libudev-dev libncurses-dev \
    libncursesw5-dev git cmake build-essential
$ git clone https://github.com/Syllo/nvtop
$ cd nvtop
$ mkdir -p Release
$ cd Release
###  you can set this to /usr/local or $HOME/local or something you like
$ export CMAKE_INSTALL_PREFIX=$HOME/local/
$ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}..
$ make -j2
## if you're using $HOME/local
$ make install
## else if you're using /usr/local
$ sudo make install
### end if
$ export PATH=$CMAKE_INSTALL_PREFIX/bin:$PATH
$ which nvtop
/home/<username>/local/bin/nvtop
```

We recommend building `nvtop` from the source since you get the latest updates.

## DATA DOWNLOADS

- Download sample training data into a folder named `data`

```
$ ./cpp-package/example/get_data.sh
```

- Using MXNET in C++. Set the header file and the `LD_LIBRARY_PATH` correctly

```c++
#include <mxnet-cpp/MxNetCpp.h>
```
