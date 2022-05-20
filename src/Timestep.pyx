# distutils: language = c++
# cython: language_level=3

from _Timestep cimport Timestep
from _Dimensions cimport Dimensions
from _external_func cimport _mul_two

cimport cython
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


cdef class TimestepContainer:
    # pointer to timestep instance
    cdef timestep_ptr_t _Timestep_ptr
    cdef timestep_type_t _timestep_type
    
    # shape of particle dependent data for numpy
    cdef cnp.npy_intp _particle_dependent_shape[2]
    # shape of box for numpy
    cdef cnp.npy_intp _box_shape[1]


    cdef uint64_t n_atoms

    cdef bool _has_dimensions

    cdef bool _has_positions

    cdef bool _has_velocities

    cdef bool _has_forces


    def __cinit__(self, uint64_t n_atoms, dtype=np.float32):

        if dtype == np.float32:
            self._timestep_type = timestep_type_t.FLOAT_FLOAT
            self._Timestep_ptr.float_ptr = new Timestep[float, float](n_atoms)
            self._has_positions = self._Timestep_ptr.float_ptr.has_positions
            self._has_dimensions = self._Timestep_ptr.float_ptr.has_dimensions
        
        elif dtype == np.float64:
            self._timestep_type = timestep_type_t.DOUBLE_DOUBLE
            self._Timestep_ptr.double_ptr = new Timestep[double, double](n_atoms)
            self._has_positions = self._Timestep_ptr.double_ptr.has_positions
            self._has_dimensions = self._Timestep_ptr.double_ptr.has_dimensions

        else:
            raise TypeError("dtype not supported, must be one of (np.float32, np.float64)")
        
        self.n_atoms =  n_atoms
        self._particle_dependent_shape[0] = self.n_atoms
        self._particle_dependent_shape[1] = 3
        self._box_shape[0] = 0


    
    def __dealloc__(self):
        if self._timestep_type == FLOAT_FLOAT:
            del self._Timestep_ptr.float_ptr
        elif self._timestep_type == DOUBLE_DOUBLE:
            del self._Timestep_ptr.double_ptr
        else:
            pass

    @property
    def dtype(self):
        if self._timestep_type == FLOAT_FLOAT:
            return np.float32
        elif self._timestep_type == DOUBLE_DOUBLE:
            return np.float64 
    
    cdef inline _to_numpy_from_spec(self, int ndim, cnp.npy_intp* shape, int npy_type, void* pointer):
        array = cnp.PyArray_SimpleNewFromData(ndim, shape, npy_type, pointer)
        cnp.PyArray_SetBaseObject(array, self)
        cnp.Py_INCREF(self)
        return array 

    @property
    def has_positions(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._has_positions = self._Timestep_ptr.float_ptr.has_positions
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._has_positions = self._Timestep_ptr.double_ptr.has_positions
        return self._has_positions

    @property
    def has_dimensions(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._has_dimensions = self._Timestep_ptr.float_ptr.has_dimensions
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._has_dimensions = self._Timestep_ptr.double_ptr.has_dimensions
        return self._has_dimensions
    
    @property
    def has_velocities(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._has_velocities = self._Timestep_ptr.float_ptr.has_velocities
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._has_velocities = self._Timestep_ptr.double_ptr.has_velocities
        return self._has_velocities
    
    @property
    def has_forces(self):
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._has_forces = self._Timestep_ptr.float_ptr.has_forces
        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._has_forces = self._Timestep_ptr.double_ptr.has_forces
        return self._has_forces


    @property
    def positions(self):
        if self._has_positions:
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                arr = self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_FLOAT,self._Timestep_ptr.float_ptr.positions.data())
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                arr =  self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_DOUBLE,self._Timestep_ptr.double_ptr.positions.data())
        else:
            raise ValueError("This Timestep has no position information")

        return arr

 
    @positions.setter
    def positions(self,  cnp.ndarray new_positions):
        # size checks
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._Timestep_ptr.float_ptr.SetPositions(new_positions.flatten())
            self._has_positions = True

        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._Timestep_ptr.double_ptr.SetPositions(new_positions.flatten())
            self._has_positions = True



    @property
    def dimensions(self):
        if self._has_dimensions:
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                self._box_shape[0] = self._Timestep_ptr.float_ptr.unitcell.size
                arr = self._to_numpy_from_spec(1, self._box_shape, cnp.NPY_FLOAT,self._Timestep_ptr.float_ptr.unitcell.box.data())
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                self._box_shape[0] = self._Timestep_ptr.double_ptr.unitcell.size
                arr = self._to_numpy_from_spec(1,self._box_shape, cnp.NPY_DOUBLE,self._Timestep_ptr.double_ptr.unitcell.box.data())
        else:
            raise ValueError("This Timestep has no dimension information")

        return arr

    
    @dimensions.setter
    def dimensions(self, cnp.ndarray new_dimensions):
        if new_dimensions.ndim  >= 2:
            raise ValueError("box cannot be set with multidimensional array")
        cdef size_t first_dim =  new_dimensions.shape[0]
        if (first_dim != 9) and (first_dim != 6):
            raise ValueError("box cannot be set with first dimension shape {}, must be one of (6, 9)".format(first_dim))
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._Timestep_ptr.float_ptr.SetDimensions(new_dimensions.flatten())
            self._has_dimensions = True
        elif self._timestep_type == timestep_type_t.DOUBLE_DOUBLE:
            self._Timestep_ptr.double_ptr.SetDimensions(new_dimensions.flatten())
            self._has_dimensions = True

    @property
    def velocities(self):
        if self._has_velocities:
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                arr = self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_FLOAT,self._Timestep_ptr.float_ptr.velocities.data())
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                arr =  self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_DOUBLE,self._Timestep_ptr.double_ptr.velocities.data())
        else:
            raise ValueError("This Timestep has no velocities information")

        return arr

 
    @velocities.setter
    def velocities(self,  cnp.ndarray new_velocities):
        # size checks
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._Timestep_ptr.float_ptr.SetVelocities(new_velocities.flatten())
            self._has_velocities = True

        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._Timestep_ptr.double_ptr.SetVelocities(new_velocities.flatten())
            self._has_velocities = True


    @property
    def forces(self):
        if self._has_forces:
            if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
                arr = self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_FLOAT,self._Timestep_ptr.float_ptr.forces.data())
            elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
                arr =  self._to_numpy_from_spec(2,self._particle_dependent_shape,cnp.NPY_DOUBLE,self._Timestep_ptr.double_ptr.forces.data())
        else:
            raise ValueError("This Timestep has no force information")

        return arr

 
    @forces.setter
    def forces(self,  cnp.ndarray new_forces):
        # size checks
        if self._timestep_type  ==  timestep_type_t.FLOAT_FLOAT:
            self._Timestep_ptr.float_ptr.SetForces(new_forces.flatten())
            self._has_forces = True

        elif self._timestep_type  ==  timestep_type_t.DOUBLE_DOUBLE:
            self._Timestep_ptr.double_ptr.SetForces(new_forces.flatten())
            self._has_forces = True
    
    

@cython.boundscheck(False)  
@cython.wraparound(False)
def modify_values(cython.floating[:,::1] input not None, cython.floating[:,::1] output not None):
    _mul_two(&input[0,0], &output[0,0], input.shape[0]*input.shape[1])
