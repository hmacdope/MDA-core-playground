cdef extern from "external_func.h":
    void _mul_two[T](T* input, T* out, size_t n_elem)