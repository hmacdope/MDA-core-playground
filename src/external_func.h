#include <cstddef>

template<typename T>
void _mul_two(T* input, T* out, std::size_t n_elem) {
    for(std::size_t i=0; i<n_elem; i++) {
        out[i] = 2* input[i];
    }
}