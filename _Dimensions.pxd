# distutils: language = c++

from libcpp.vector cimport vector


cdef extern from "Dimensions.h" namespace "mdacore":
    cdef cppclass OrthogonalDimensions[T]:
        OrthogonalDimensions()
        OrthogonalDimensions(const vector[T] &source) except +

    cdef cppclass TriclinicDimensions[T]:
        TriclinicDimensions()
        TriclinicDimensions(const vector[T] &source) except +
        
