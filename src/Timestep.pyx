# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep
from _Dimensions cimport Dimensions

from cython cimport  floating
from cython.operator cimport dereference
from libcpp.vector cimport vector
from libc.stdint cimport uint64_t


import numpy as np
cimport numpy as cnp
cnp.import_array()


ctypedef enum arr_type_t:
    FLOAT
    DOUBLE

ctypedef enum timestep_type_t:
    FLOAT_FLOAT
    DOUBLE_DOUBLE

ctypedef union timestep_ptr_t:
    void *null_ptr
    Timestep[float, float] *float_ptr
    Timestep[double, double] *double_ptr

ctypedef union dimensions_ptr_t:
    void *null_ptr
    Dimensions[float] *float_ptr
    Dimensions[double] *double_ptr


cdef class TimestepContainer:
    cdef timestep_ptr_t _Timestep_ptr
    cdef dimensions_ptr_t _Dimensions_ptr
    cdef timestep_type_t _timestep_type
    cdef uint64_t n_atoms



    def __cinit__(self, uint64_t n_atoms, dtype=np.float32):
        if dtype == np.float32:
            self._timestep_type = timestep_type_t.FLOAT_FLOAT
            self._Timestep_ptr.float_ptr = new Timestep[float, float](n_atoms)
            self._Dimensions_ptr.float_ptr =  &dereference(self._Timestep_ptr.float_ptr).unitcell
        
        elif dtype == np.float64:
            self._timestep_type = timestep_type_t.DOUBLE_DOUBLE
            self._Timestep_ptr.double_ptr = new Timestep[double, double](n_atoms)
            self._Dimensions_ptr.double_ptr =  &dereference(self._Timestep_ptr.double_ptr).unitcell

        self.n_atoms =  n_atoms
    
    def __dealloc__(self):
        if self._timestep_type == FLOAT_FLOAT:
            del self._Timestep_ptr.float_ptr
        elif self._timestep_type == DOUBLE_DOUBLE:
            del self._Timestep_ptr.double_ptr
        else:
            pass


    @property
    def positions(self):
        cdef float[:,::1] posview = <float[:self.n_atoms, :3]>dereference(self._Timestep_ptr.float_ptr).positions.data()
        cdef cnp.ndarray pos_ndarr = np.asarray(posview)
        return pos_ndarr
    
    @positions.setter
    def positions(self,  cnp.ndarray[cnp.float32_t, ndim=2] newpos):
        dereference(self._Timestep_ptr.float_ptr).SetPositions(newpos.flatten())

    @property
    def dimensions(self):
        cdef box_size = dereference(self._Dimensions_ptr.float_ptr).size
        cdef float[::1] boxview = <float[:box_size]>dereference(self._Dimensions_ptr.float_ptr).box.data()
        cdef cnp.ndarray box_ndarr = np.asarray(boxview)
        return box_ndarr
    
    @dimensions.setter
    def dimensions(self, cnp.ndarray[cnp.float32_t, ndim=2] newbox):
        if newbox.ndim  >= 2:
            raise ValueError("box cannot be set with multidimensional array")
        cdef size_t first_dim =  newbox.shape[0]
        if first_dim > dereference(self._Dimensions_ptr.float_ptr).max_size:
            raise ValueError("box cannot be set with first dimension shape {}".format(first_dim))
        dereference(self._Dimensions_ptr.float_ptr).box = newbox.flatten()



