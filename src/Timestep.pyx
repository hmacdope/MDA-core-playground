# distutils: language = c++
# cython: language_level=3

cimport cython
from libcpp.vector cimport vector
from libc.stdint cimport uint64_t
from libcpp cimport bool



import numpy as np
cimport numpy as cnp
cnp.import_array()


cdef class TimestepContainer:

    cdef uint64_t n_atoms

    cdef bool _has_dimensions

    cdef bool _has_positions

    cdef bool _has_velocities

    cdef bool _has_forces

    cdef cnp.ndarray _dimensions
    cdef cnp.ndarray _positions
    cdef cnp.ndarray _velocities
    cdef cnp.ndarray _forces



    def __cinit__(self, uint64_t n_atoms, dtype=np.float32):
        self.n_atoms =  n_atoms
        
        self._has_dimensions = False
        self._has_positions = False
        self._has_velocities = False
        self._has_forces = False
        



    
    def __dealloc__(self):
            pass

    @property
    def has_positions(self):
        return self._has_positions

    @property
    def has_dimensions(self):
        return self._has_dimensions
    
    @property
    def has_velocities(self):
        return self._has_velocities
    
    @property
    def has_forces(self):
        return self._has_forces


    @property
    def positions(self):
        if self._has_positions:
            return self._positions
        else:
            raise ValueError("This Timestep has no position information")

        return arr

 
    @positions.setter
    @cython.boundscheck(False)  
    @cython.wraparound(False)
    def positions(self,  cnp.ndarray new_positions):
        self._positions = new_positions
        self._has_positions = True



    @property
    def dimensions(self):
        if self._has_dimensions:
           return self._dimensions
        else:
            raise ValueError("This Timestep has no dimension information")

    
    @dimensions.setter
    @cython.boundscheck(False)  
    @cython.wraparound(False)
    def dimensions(self, cnp.ndarray new_dimensions):
        self._dimensions = new_dimensions
        self._has_dimensions = True


    @property
    def velocities(self):
        if self._has_velocities:
            return self._velocities
        else:
            raise ValueError("This Timestep has no velocities information")


 
    @velocities.setter
    @cython.boundscheck(False)  
    @cython.wraparound(False)
    def velocities(self,  cnp.ndarray new_velocities):
        self._velocities = new_velocities
        self._has_velocities = True



    @property
    def forces(self):
        if self._has_forces:
          return self._forces
        else:
            raise ValueError("This Timestep has no force information")


 
    @forces.setter
    @cython.boundscheck(False)  
    @cython.wraparound(False)
    def forces(self,  cnp.ndarray new_forces):
        self._forces = new_forces
        self._has_forces = True

    
    
