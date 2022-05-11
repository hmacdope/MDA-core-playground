#ifndef MDA_DIMENSIONS_H_
#define MDA_DIMENSIONS_H_

#include "Util.h"
#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdio>

namespace mdacore {

template <typename T> class OrthogonalDimensions {
public:
  // expose decl of type so can be used as Dimension::type
  using type = T;
  static constexpr std::size_t size = 6;
  std::array<T, size> box;

  explicit OrthogonalDimensions(const std::vector<T> &source) {
    std::copy(source.begin(), source.end(), std::begin(box));
  }
  // Dump state
  void DebugPrint() { print_3col("OrthogonalDimensions", box); }
};

template <typename T> class TriclinicDimensions {
public:
  // expose decl of type so can be used as Dimension::type
  using type = T;

  static constexpr std::size_t size = 9;
  std::array<T, size> box;

  explicit TriclinicDimensions(const std::vector<T> &source) {
    std::copy(source.begin(), source.end(), std::begin(box));
  }
  // Dump state
  void DebugPrint() { print_3col("TriclinicDimensions", box); }
};

template <typename T> class NoDimensions {
  static constexpr std::size_t size = 0;

public:
  NoDimensions() {}
};

} // namespace mdacore

#endif // MDA_DIMENSIONS_H_