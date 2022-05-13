# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep
from _Dimensions cimport OrthogonalDimensions

from libcpp.vector cimport vector
from libc.stdint cimport uint64_t


import numpy as np
cimport numpy as cnp


cdef class Timestep_F_F:
    cdef Timestep[float, OrthogonalDimensions[float]] _Timestep
    cdef OrthogonalDimensions[float] _OrthogonalDimensions
    cdef uint64_t n_atoms

    def __cinit__(self, uint64_t n_atoms, vector[float] box):
        self._Timestep = Timestep[float, OrthogonalDimensions[float]](n_atoms, box)
        self._OrthogonalDimensions = self._Timestep.unitcell
        self.n_atoms =  self._Timestep.n_atoms

    @property
    def positions(self):
        cdef float[::1] posview = <float[:3*self.n_atoms]>self._Timestep.positions.data()
        cdef cnp.ndarray pos_ndarr = np.asarray(posview)
        return pos_ndarr
    
    @positions.setter
    def positions(self,  cnp.ndarray[cnp.float32_t, ndim=1] newpos):
        self._Timestep.positions = newpos


cdef class Timestep_D_D:
    cdef Timestep[double, OrthogonalDimensions[double]] _Timestep
    cdef OrthogonalDimensions[double] _OrthogonalDimensions
    cdef uint64_t n_atoms

    def __cinit__(self, uint64_t n_atoms, vector[double] box):
        self._Timestep = Timestep[double, OrthogonalDimensions[double]](n_atoms, box)
        self._OrthogonalDimensions = self._Timestep.unitcell
        self.n_atoms =  self._Timestep.n_atoms

    @property
    def positions(self):
        cdef double[::1] posview = <double[:3*self.n_atoms]>self._Timestep.positions.data()
        cdef cnp.ndarray pos_ndarr = np.asarray(posview)
        return pos_ndarr
    
    @positions.setter
    def positions(self,  cnp.ndarray[cnp.float64_t, ndim=1] newpos):
        self._Timestep.positions = newpos