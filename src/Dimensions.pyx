# distutils: language = c++

from _Dimensions cimport OrthogonalDimensions


cdef class OrthogonalDimensions_F:
    cdef OrthogonalDimensions[float] _OrthogonalDimensions
    
    def __cinit__(self, list box):
        self._OrthogonalDimensions = OrthogonalDimensions[float](box)

    @property
    def box(self):
        return self._OrthogonalDimensions.box
    
    @box.setter
    def box(self, box):
        self._OrthogonalDimensions.box = box

