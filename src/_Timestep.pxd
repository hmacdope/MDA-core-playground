# distutils: language = c++

from libcpp.vector cimport vector
from libc.stdint cimport uint64_t
from libcpp cimport bool

from _Dimensions cimport Dimensions


cdef extern from "Timestep.h" namespace "mdacore":
    cdef cppclass Timestep[T,U]:
        # how do I pass through the T  of U through
        Timestep(const uint64_t n_atoms)
        void SetDimensions(const vector[U] &pos) 
        void SetPositions( T* pos) 
        void SetVelocities( T* vel)
        void SetForces( T* frc)

        Dimensions[U] unitcell

        uint64_t n_atoms

        T* positions
        T* velocities
        T* forces

        bool has_dimensions
        bool has_positions
        bool has_velocities
        bool has_forces



