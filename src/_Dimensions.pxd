# distutils: language = c++
#cython: language_level=3

from libcpp.vector cimport vector


cdef extern from "Dimensions.h" namespace "mdacore":
    cdef cppclass OrthogonalDimensions[T]:
        OrthogonalDimensions()
        OrthogonalDimensions(const vector[T] &source) except + ValueError

        size_t    size
        ctypedef T type
        vector[T] box

    cdef cppclass TriclinicDimensions[T]:
        TriclinicDimensions()
        TriclinicDimensions(const vector[T] &source) except + ValueError

        size_t    size
        ctypedef T type
        vector[T] box
        
