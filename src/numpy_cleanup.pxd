#cython: language_level=3


cimport numpy as cnp

cdef void set_base(cnp.ndarray arr, void * carr)