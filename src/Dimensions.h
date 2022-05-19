#ifndef MDA_DIMENSIONS_H_
#define MDA_DIMENSIONS_H_

#include "Util.h"
#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdio>

namespace mdacore {

template <typename T> class Dimensions {
public:
  // expose decl of type so can be used as Dimension::type
  using type = T;
  std::vector<T> box;
  static constexpr std::size_t max_size = 9;
  std::size_t size = 0;


  Dimensions() {box.reserve(max_size);}

  explicit Dimensions(const std::vector<T> &source) {
    box.reserve(max_size);
    box = source;
    size = box.size();
  }

  void SetBox(const std::vector<T> &source) {
    box = source;
    size = box.size();
  }

  // Dump state
  void DebugPrint() { print_3col("Dimensions", box); }
};

} // namespace mdacore

#endif // MDA_DIMENSIONS_H_