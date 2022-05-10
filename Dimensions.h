#ifndef MDA_DIMENSIONS_H_
#define MDA_DIMENSIONS_H_

#include <cstddef>
#include <cstdio>

namespace mdacore {

template <typename T> class OrthogonalDimensions {
public:
  typedef T type;
  static constexpr std::size_t size = 6;
  T box[size];

  OrthogonalDimensions(const T *src) {
    for (std::size_t i = 0; i < size; i++) {
      box[i] = src[i];
    }
  }
  // Dump state
  void DebugPrint() {
    std::printf("OrthogonalDimensions values\n");
    for (std::size_t i = 0; i < size; i += 3) {
      std::printf(" %f %f %f \n", box[i], box[i + 1], box[i + 2]);
    }
  }
};

template <typename T> class TriclinicDimensions {
public:
  typedef T type;
  static constexpr std::size_t size = 9;
  T box[size];

  TriclinicDimensions(const T *src) {
    for (std::size_t i = 0; i < size; i++) {
      box[i] = src[i];
    }
  }
  // Dump state
  void DebugPrint() {
    std::printf("TriclinicDimensions values\n");
    for (std::size_t i = 0; i < size; i += 3) {
      std::printf(" %f %f %f \n", box[i], box[i + 1], box[i + 2]);
    }
  }
};

template <typename T> class NoDimensions {
  static constexpr std::size_t size = 0;

public:
  NoDimensions() {}
};

} // namespace mdacore

#endif // MDA_DIMENSIONS_H_