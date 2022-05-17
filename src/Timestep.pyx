# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep
from _Dimensions cimport Dimensions

from cython cimport  floating
from cython.operator cimport dereference
from libcpp.vector cimport vector
from libc.stdint cimport uint64_t
from libcpp cimport bool



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

    cdef bool has_positions
    cdef cnp.ndarray positions
    cdef cnp.float32_t[:,::1] _posview_f
    cdef cnp.float64_t[:,::1] _posview_d

    cdef bool has_dimensions
    cdef cnp.ndarray dimensions
    cdef size_t    _box_size
    cdef cnp.float32_t[::1] _boxview_f
    cdef cnp.float64_t[::1] _boxview_d

    cdef bool has_velocities
    cdef cnp.ndarray velocities
    cdef cnp.float32_t[:,::1] _velview_f
    cdef cnp.float64_t[:,::1] _velview_d

    cdef bool has_forces
    cdef cnp.ndarray forces
    cdef cnp.float32_t[:,::1] _frcview_f
    cdef cnp.float64_t[:,::1] _frcview_d

    def __cinit__(self, uint64_t n_atoms, dtype=np.float32):

        if dtype == np.float32:
            self._timestep_type = timestep_type_t.FLOAT_FLOAT
            self._Timestep_ptr.float_ptr = new Timestep[float, float](n_atoms)
            self._Dimensions_ptr.float_ptr =  &dereference(self._Timestep_ptr.float_ptr).unitcell
            self.has_positions = dereference(self._Timestep_ptr.float_ptr).has_positions
            self.has_dimensions = dereference(self._Timestep_ptr.float_ptr).has_dimensions
        
        elif dtype == np.float64:
            self._timestep_type = timestep_type_t.DOUBLE_DOUBLE
            self._Timestep_ptr.double_ptr = new Timestep[double, double](n_atoms)
            self._Dimensions_ptr.double_ptr =  &dereference(self._Timestep_ptr.double_ptr).unitcell
            self.has_positions = dereference(self._Timestep_ptr.double_ptr).has_positions
            self.has_dimensions = dereference(self._Timestep_ptr.double_ptr).has_dimensions

        else:
            raise TypeError("dtype not supported, must be one of (np.float32, np.float64)")
        self.n_atoms =  n_atoms

    
    def __dealloc__(self):
        if self._timestep_type == FLOAT_FLOAT:
            del self._Timestep_ptr.float_ptr
        elif self._timestep_type == DOUBLE_DOUBLE:
            del self._Timestep_ptr.double_ptr
        else:
            pass

    @property
    def has_positions(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self.has_positions = dereference(self._Timestep_ptr.float_ptr).has_positions
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self.has_positions = dereference(self._Timestep_ptr.double_ptr).has_positions
        return self.has_positions

    @property
    def has_dimensions(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self.has_dimensions = dereference(self._Timestep_ptr.float_ptr).has_dimensions
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self.has_dimensions = dereference(self._Timestep_ptr.double_ptr).has_dimensions
        return self.has_dimensions


    @property
    def positions(self):
        if self.has_positions:
            # we use memoryview -> ndarray with no copy, asarray manages the memory from the python side
            #is PyArray_SimpleNewFromData faster? 
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                self._posview_f = <cnp.float32_t[:self.n_atoms, :3]>dereference(self._Timestep_ptr.float_ptr).positions.data()
                self.positions =  np.asarray(self._posview_f)
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                self._posview_d = <cnp.float64_t[:self.n_atoms, :3]>dereference(self._Timestep_ptr.double_ptr).positions.data()
                self.positions =  np.asarray(self._posview_d)
        else:
            raise ValueError("This Timestep has no position information")

        return self.positions

 
    @positions.setter
    def positions(self,  cnp.ndarray new_positions):
        # size checks
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            dereference(self._Timestep_ptr.float_ptr).SetPositions(new_positions.flatten())
            dereference(self._Timestep_ptr.float_ptr).has_positions = True
            self.has_dimensions = True

        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            dereference(self._Timestep_ptr.double_ptr).SetPositions(new_positions.flatten())
            dereference(self._Timestep_ptr.double_ptr).has_positions = True
            self.has_dimensions = True



    @property
    def dimensions(self):
        if self.has_dimensions:
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                self._box_size = dereference(self._Dimensions_ptr.float_ptr).size
                self._boxview_f = <cnp.float32_t[:self._box_size]>dereference(self._Dimensions_ptr.float_ptr).box.data()
                self.dimensions = np.asarray(self._boxview_f)
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                self._box_size = dereference(self._Dimensions_ptr.double_ptr).size
                self._boxview_d = <cnp.float64_t[:self._box_size]>dereference(self._Dimensions_ptr.double_ptr).box.data()
                self.dimensions = np.asarray(self._boxview_d)
        else:
            raise ValueError("This Timestep has no dimension information")

        return self.dimensions

    
    @dimensions.setter
    def dimensions(self, cnp.ndarray new_dimensions):
        if new_dimensions.ndim  >= 2:
            raise ValueError("box cannot be set with multidimensional array")
        cdef size_t first_dim =  new_dimensions.shape[0]
        if (first_dim != 9) and (first_dim != 6):
            raise ValueError("box cannot be set with first dimension shape {}, must be one of (6, 9)".format(first_dim))
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            dereference(self._Timestep_ptr.float_ptr).SetDimensions(new_dimensions.flatten())
            dereference(self._Timestep_ptr.float_ptr).has_dimensions = True
            self.has_dimensions = True
        elif self._timestep_type == timestep_type_t.DOUBLE_DOUBLE:
            dereference(self._Timestep_ptr.double_ptr).SetDimensions(new_dimensions.flatten())
            dereference(self._Timestep_ptr.double_ptr).has_dimensions = True
            self.has_dimensions = True





