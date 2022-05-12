cimport numpy as cnp
from libc.stdlib cimport malloc, free

cdef class _finalizer:
    cdef void * _data
    def __dealloc__(self):
        print("_finalizer.__dealloc__")
        if self._data is not NULL:
            free(self._data)


cdef void set_base(cnp.ndarray arr, void * carr):
    cdef _finalizer f = _finalizer()
    f._data = <void*>carr
    cnp.set_array_base(arr, f)
