# distutils: language = c++

from _Timestep cimport Timestep

cdef class PyTimestep:
    cdef Timestep cxx_Timestep
