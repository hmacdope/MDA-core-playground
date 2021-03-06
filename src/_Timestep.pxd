# distutils: language = c++

from libcpp.vector cimport vector
from libc.stdint cimport uint64_t


cdef extern from "Timestep.h" namespace "mdacore":
    cdef cppclass Timestep[T,U]:
        Timestep()
        # how do I pass through the T  of U through
        Timestep(const uint64_t n_atoms, const vector[T] &box)
        void SetPositions(const vector[T] &pos) 
        void SetVelocities(const vector[T] &vel)
        void SetForces(const vector[T] &frc)

        U unitcell

        uint64_t n_atoms

        vector[T] positions
        vector[T] velocities
        vector[T] forces

