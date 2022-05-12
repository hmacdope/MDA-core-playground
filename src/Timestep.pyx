# distutils: language = c++
#cython: language_level=3

from _Timestep cimport Timestep

cdef class PyTimestep:
    cdef Timestep cxx_Timestep
