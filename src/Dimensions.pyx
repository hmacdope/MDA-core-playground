# distutils: language = c++
#cython: language_level=3

from _Dimensions cimport OrthogonalDimensions
from libcpp.vector cimport vector

import numpy as np
cimport numpy as cnp


cdef class Dimensions_F:
    cdef Dimensions_F[float] _Dimensions_F
    cdef size_t _boxsize 
    
    def __cinit__(self, vector[float] vec ):
        self._OrthogonalDimensions = OrthogonalDimensions[float](vec)
        self._boxsize = self._OrthogonalDimensions.size


    @property
    def box(self):
        # leaks mem
        cdef float[::1] boxview = <float[:6]>self._OrthogonalDimensions.box.data()
        cdef cnp.ndarray box_ndarr = np.asarray(boxview)
        return box_ndarr
    
    @box.setter
    def box(self, cnp.ndarray[cnp.float32_t, ndim=1] newbox):
        if newbox.ndim  >= 2:
            raise ValueError("box cannot be set with multidimensional array")
        cdef size_t first_dim =  newbox.shape[0]
        if first_dim != self._boxsize:
            raise ValueError("box cannot be set with first dimension shape {}".format(first_dim))
        self._OrthogonalDimensions.box = newbox



