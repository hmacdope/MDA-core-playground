# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep
from _Dimensions cimport Dimensions

from libcpp.vector cimport vector
from libc.stdint cimport uint64_t


import numpy as np
cimport numpy as cnp


cdef class Timestep_F_F:
    cdef Timestep[float, float] _Timestep
    cdef Dimensions[float] _Dimensions
    cdef uint64_t n_atoms

    def __cinit__(self, uint64_t n_atoms, vector[float] box):
        self._Timestep = Timestep[float, float](n_atoms, box)
        self._Dimensions = self._Timestep.unitcell
        self.n_atoms =  self._Timestep.n_atoms

    @property
    def positions(self):
        cdef float[::1] posview = <float[:3*self.n_atoms]>self._Timestep.positions.data()
        cdef cnp.ndarray pos_ndarr = np.asarray(posview)
        return pos_ndarr
    
    @positions.setter
    def positions(self,  cnp.ndarray[cnp.float32_t, ndim=1] newpos):
        self._Timestep.positions = newpos

