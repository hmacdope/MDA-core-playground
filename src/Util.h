

#ifndef MDA_UTIL_H_
#define MDA_UTIL_H_

#include <cstddef>
#include <cstdio>
#include <string>
#include <vector>
#include <array>

namespace mdacore {

template <typename T>
void print_3col(const std::string &tag, const std::vector<T> &values) {
  std::printf("%s: \n", tag.c_str());
  for (std::size_t i = 0; i < values.size(); i += 3) {
    std::printf(" %.3f %.3f %.3f \n", values[i], values[i + 1], values[i + 2]);
  }
}

template <typename T, std::size_t S>
void print_3col(const std::string &tag, const std::array<T, S> &values) {
  std::printf("%s: \n", tag.c_str());
  for (std::size_t i = 0; i < values.size(); i += 3) {
    std::printf(" %.3f %.3f %.3f \n", values[i], values[i + 1], values[i + 2]);
  }
}

} // namespace mdacore

#endif // MDA_UTIL_H_