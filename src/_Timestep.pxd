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
        void SetPositions(const vector[T] &pos) 
        void SetVelocities(const vector[T] &vel)
        void SetForces(const vector[T] &frc)

        Dimensions[U] unitcell

        uint64_t n_atoms

        vector[T] positions
        vector[T] velocities
        vector[T] forces

        bool has_dimensions
        bool has_positions
        bool has_velocities
        bool has_forces



