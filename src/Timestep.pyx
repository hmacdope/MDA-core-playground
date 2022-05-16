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
    FLOAT_DOUBLE # likely most common
    DOUBLE_FLOAT
    DOUBLE_DOUBLE

ctypedef union timestep_ptr_t:
    void *null_ptr
    Timestep[float, float] *float_float_ptr
    Timestep[float, double] *float_double_ptr
    Timestep[double, float] *double_float_ptr
    Timestep[double, double] *double_double_ptr

ctypedef union dimensions_ptr_t:
    void *null_ptr
    Dimensions[float] *float_ptr
    Dimensions[double] *double_ptr


cdef class TimestepContainer:
    cdef timestep_ptr_t _Timestep_ptr
    cdef dimensions_ptr_t _Dimensions_ptr
    cdef arr_type_t _dimtype
    cdef arr_type_t _postype
    cdef timestep_type_t _timestep_type
    cdef uint64_t n_atoms


    def __cinit__(self, uint64_t n_atoms, cnp.ndarray box):
        if box.dtype == np.float32:
            self._Timestep_ptr.float_float_ptr = new Timestep[float, float](n_atoms, box)
            self._dimtype = arr_type_t.FLOAT
            self._timestep_type = timestep_type_t.FLOAT_FLOAT
            self._Dimensions_ptr.float_ptr =  &dereference(self._Timestep_ptr.float_float_ptr).unitcell

        elif box.dtype == np.float64:
            self._Timestep_ptr.float_double_ptr = new Timestep[float, double](n_atoms, box)
            self._dimtype = arr_type_t.DOUBLE
            self._timestep_type = timestep_type_t.FLOAT_DOUBLE
            self._Dimensions_ptr.double_ptr =  &dereference(self._Timestep_ptr.float_double_ptr).unitcell
        self.n_atoms =  n_atoms
    
    def __dealloc__(self):
        if self._timestep_type == FLOAT_FLOAT:
            del self._Timestep_ptr.float_float_ptr
        if self._timestep_type == FLOAT_DOUBLE:
            del self._Timestep_ptr.float_double_ptr
        if self._timestep_type == DOUBLE_FLOAT:
            del self._Timestep_ptr.double_float_ptr
        if self._timestep_type == DOUBLE_DOUBLE:
            del self._Timestep_ptr.double_double_ptr


    @property
    def positions(self):
        cdef float[:,::1] posview = <float[:self.n_atoms, :3]>dereference(self._Timestep_ptr.float_float_ptr).positions.data()
        cdef cnp.ndarray pos_ndarr = np.asarray(posview)
        return pos_ndarr
    
    @positions.setter
    def positions(self,  cnp.ndarray[cnp.float32_t, ndim=2] newpos):
        cdef temp = newpos.flatten()
        dereference(self._Timestep_ptr.float_float_ptr).SetPositions(temp)

    @property
    def dimensions(self):
        cdef box_size = dereference(self._Dimensions_ptr.float_ptr).size
        if 
        cdef float[::1] boxview = <float[:box_size]>dereference(self._Dimensions_ptr.float_ptr).box.data()
        cdef cnp.ndarray box_ndarr = np.asarray(boxview)
        return box_ndarr
    
    @dimensions.setter
    def dimensions(self, cnp.ndarray[cnp.float32_t, ndim=1] newbox):
        if newbox.ndim  >= 2:
            raise ValueError("box cannot be set with multidimensional array")
        cdef size_t first_dim =  newbox.shape[0]
        if first_dim > self._Dimensions.max_size:
            raise ValueError("box cannot be set with first dimension shape {}".format(first_dim))
        self._Dimensions.box = newbox


