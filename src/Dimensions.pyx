# distutils: language = c++

from _Dimensions cimport OrthogonalDimensions
from libcpp.vector cimport vector
 


cdef class OrthogonalDimensions_F:
    cdef OrthogonalDimensions[float] _OrthogonalDimensions
    cdef float* _box_ptr
    
    def __cinit__(self, vector[float] vec ):
        self._OrthogonalDimensions = OrthogonalDimensions[float](vec)
        self._box_ptr = self._OrthogonalDimensions.box.data()

    @property
    def box(self):
        return self._OrthogonalDimensions.box
    
    @box.setter
    def box(self, list newbox):
        self._OrthogonalDimensions.box = newbox



