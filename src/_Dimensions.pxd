# distutils: language = c++
#cython: language_level=3

from libcpp.vector cimport vector


cdef extern from "Dimensions.h" namespace "mdacore":
    cdef cppclass Dimensions[T]:
        Dimensions()
        Dimensions(const vector[T] &source)
        void SetBox(const vector[T] &source)


        size_t    max_size
        size_t    size
        vector[T] box

        void DebugPrint()

        
