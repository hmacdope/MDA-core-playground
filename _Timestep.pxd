# distutils: language = c++

from libcpp.vector cimport vector

cdef extern from "Timestep.h" namespace "mdacore":
    cdef cppclass Timestep[T,U]:
        Timestep()
        void SetPositions(const vector[T] &pos) 
        void SetVelocities(const vector[T] &vel)
        void SetForces(const vector[T] &frc)

