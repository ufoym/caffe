cp Makefile Makefile.example
cp Makefile.config.example Makefile.config

sed -i 's/opencv_core opencv_highgui opencv_imgproc/opencv_imgproc opencv_imgcodecs opencv_highgui opencv_core opencv_hal libjpeg libpng zlib dl/g' Makefile
sed -i 's/-l\$(PROJECT)/-Wl,--whole-archive \.build_release\/lib\/libcaffe\.a -Wl,--no-whole-archive/g' Makefile
sed -i 's/\$(STATIC_NAME) \$(DYNAMIC_NAME) tools examples/\$(STATIC_NAME) tools py/g' Makefile

sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/g' Makefile.config
sed -i 's/BLAS := atlas/BLAS := open/g' Makefile.config
sed -i 's/\/usr\/local\/include/3rdparty\/include 3rdparty\/include\/openblas 3rdparty\/include\/hdf5/g' Makefile.config
sed -i 's/\/usr\/local\/lib \/usr\/lib/3rdparty\/lib/g' Makefile.config

sed -i 's/bp::class_<vector<shared_ptr<Net<Dtype> > > >("NetVec")/\/\/bp::class_<vector<shared_ptr<Net<Dtype> > > >("NetVec")/g' python/caffe/_caffe.cpp
sed -i 's/\.def(bp::vector_indexing_suite<vector<shared_ptr<Net<Dtype> > >, true>());/\/\/\.def(bp::vector_indexing_suite<vector<shared_ptr<Net<Dtype> > >, true>());/g' python/caffe/_caffe.cpp
sed -i 's/bp::class_<vector<bool> >("BoolVec")/\/\/bp::class_<vector<bool> >("BoolVec")/g' python/caffe/_caffe.cpp
sed -i 's/\.def(bp::vector_indexing_suite<vector<bool> >());/\/\/\.def(bp::vector_indexing_suite<vector<bool> >());/g' python/caffe/_caffe.cpp

sudo apt-get install build-essential python-dev python-numpy gfortran -y

cd 3rdparty/src
tar -xf boost.tar.gz
mv boost ../include/

cd 3rdparty/src
tar -xf openblas.tar.gz
mv OpenBLAS* openblas
cd openblas
make
cp libopenblas.a ../../lib
rm -rf openblas

cd ../../..
export PATH=3rdparty/bin/:$PATH; chmod +x 3rdparty/bin/protoc; make all
