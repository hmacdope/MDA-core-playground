# distutils: language = c++

from _Dimensions cimport OrthogonalDimensions
from libcpp.vector cimport vector
from numpy_cleanup cimport set_base

import numpy as np
cimport numpy as cnp


cdef class OrthogonalDimensions_F:
    cdef OrthogonalDimensions[float] _OrthogonalDimensions
    
    def __cinit__(self, vector[float] vec ):
        self._OrthogonalDimensions = OrthogonalDimensions[float](vec)

    @property
    def box(self):
        # leaks mem
        cdef float[::1] boxview = <float[:6]>self._OrthogonalDimensions.box.data()
        cdef cnp.ndarray box_ndarr = np.asarray(boxview)
        return box_ndarr
    
    @box.setter
    def box(self, list newbox):
        self._OrthogonalDimensions.box = newbox



