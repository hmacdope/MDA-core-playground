# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep
f

cdef class Timesetep_F:
    cdef Timestep[float] _OrthogonalDimensions
    cdef size_t _boxsize 
    
    def __cinit__(self, vector[float] vec ):
        self._OrthogonalDimensions = OrthogonalDimensions[float](vec)
        self._boxsize = self._OrthogonalDimensions.size


    @property
    def box(self):
        cdef float[::1] boxview = <float[:6]>self._OrthogonalDimensions.box.data()
        cdef cnp.ndarray box_ndarr = np.asarray(boxview)
        return box_ndarr
    
    @box.setter
    def box(self, list newbox):
        self._OrthogonalDimensions.box = newbox
